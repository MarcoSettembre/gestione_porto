import datetime
import json
from collections import defaultdict

from django.core.exceptions import ValidationError

from django.contrib.auth.password_validation import validate_password

from django.contrib import messages
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.models import Group, AbstractUser
from django.contrib.auth import authenticate, login, logout, update_session_auth_hash
from django.contrib.auth.decorators import login_required
from core.models import *
from django.db import IntegrityError, DataError, connection, DatabaseError, transaction
from porto.decorators import group_required
from django_ratelimit.core import is_ratelimited

def get_user_role(user):
    return user.groups.all()[0].name
def redirect_by_role(request):
    role = get_user_role(request.user)
    if role == 'cliente':
        return redirect('cliente')
    elif role == 'gestore_attracco_navi':
        return redirect('banchina')
    elif role == 'gestore_navi_cargo':
        return redirect('cargo')
    elif role == 'gestore_navi_crociera':
        return redirect('crociera')
    elif role == 'gestore_magazzino':
        return redirect('magazzino')
    elif role == 'admin':
        return redirect('homepage')
    return redirect('')
def estrai_errore_db(e):
    if hasattr(e, 'args') and len(e.args) > 1:
        messaggio = e.args[1]
    else:
        messaggio = str(e)
    testo = messaggio.lower()
    if "chk" in testo:
        return "Dati inseriti non validi"
    return messaggio
def register(request):
    if request.method != "POST":
        return render(request, 'index.html')
    username=request.POST.get('username')
    password=request.POST.get('password')
    password2=request.POST.get('password2')
    ruolo = request.POST.get('ruolo')
    if password != password2:
        return render(request,'index.html', {'error': "Le password non combaciano"})
    if User.objects.filter(username=username).exists():
        return render(request, 'index.html', {'error': "Lo username inserito già esiste"})
    try:
        validate_password(username, password)
    except ValidationError as e:
        return render(request, 'index.html', {'error': "\n".join(e.messages)})
    user=User.objects.create_user(username=username, password=password)
    group=Group.objects.get(name=ruolo)
    user.groups.add(group)
    messages.success(request, 'Registrazione effettuata con successo')
    return redirect('login')
def login_view(request):
    if request.user.is_authenticated and request.user is not None:
            return redirect_by_role(request)
    if request.method != "POST":
        return render(request, 'login.html')
    username = request.POST.get('username')
    password = request.POST.get('password')
    ip_limit = is_ratelimited(request, group='login_ip', key='ip', rate='5/5m', increment=False)
    user_limit = is_ratelimited(request, group='login_user', key='post:username', rate='5/5m', increment=False)
    if ip_limit or user_limit:
        return render(request, 'login.html', {'error': "Troppi tentativi di accesso. Riprova più tardi."})
    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
        return redirect_by_role(request)
    is_ratelimited(request, group='login_ip', key='ip', rate='5/5m', increment=True)
    is_ratelimited(request, group='login_user', key='post:username', rate='5/5m', increment=True)
    return render(request, 'login.html', {'error': "Credenziali non valide"})
@login_required
def logout_view(request):
    logout(request)
    messages.success(request, 'Logout effettuato con successo')
    return redirect('login')
@login_required
def modifica_password(request):
    if request.method == 'POST':
        user=request.user
        if user.check_password(request.POST.get('password_vecchia')):
            if request.POST.get('password_nuova') != request.POST.get('password_nuova_conferma'):
                return render(request, 'modifica_password.html', {'error': "Le password non coincidono"})
            try:
                validate_password(request.POST.get('password_nuova'), user.username)
            except ValidationError as e:
                return render(request, 'modifica_password.html', {'error': "\n".join(e.messages)})
            user.set_password(request.POST.get('password_nuova'))
            user.save()
            update_session_auth_hash(request, user)
            messages.success(request, 'Password modificata con successo')
            return redirect('login')
        else:
            return render(request, 'modifica_password.html', {'error': "Password attuale non corretta"})
    return render(request, 'modifica_password.html')
@login_required
@group_required('cliente')
def cliente(request):
    return render(request, 'cliente.html')
@login_required
@group_required('gestore_attracco_navi')
def banchina(request):
    sql = """
            SELECT b.Numero, b.Settore, b.Tipo, b.Lunghezza, CONCAT(b.Numero, b.Settore) AS id
            FROM Banchina b 
            JOIN core_userbanchina ub 
            ON b.Numero = ub.numero_banchina
            AND b.Settore = ub.settore_banchina
            WHERE ub.user_id = %s
    """
    banchine=Banchina.objects.raw(sql, [request.user.id])
    return render(request, 'banchina.html', {'banchine': banchine})
@login_required
@group_required('gestore_navi_cargo')
def cargo(request):
    user_nave=UserNave.objects.filter(user=request.user).select_related('nave')
    return render(request, 'cargo.html', {'navi': user_nave})
@login_required
@group_required('gestore_navi_crociera')
def crociera(request):
    user_nave=UserNave.objects.filter(user=request.user).select_related('nave')
    return render(request, 'crociera.html', {'navi': user_nave})
@login_required
@group_required('gestore_magazzino')
def magazzino(request):
    sql = """
         SELECT 
        m.Nome,
        m.Localita,
        m.Tipo,
        m.Capacita,
        CONCAT(m.Nome, '-', m.Localita) AS id
    FROM Magazzino m
    JOIN core_usermagazzino um
      ON m.Nome = um.nome_magazzino
     AND m.Localita = um.localita_magazzino
    WHERE um.user_id = %s
          """
    magazzini = Magazzino.objects.raw(sql, [request.user.id])

    return render(request, 'magazzino.html', {'magazzini': magazzini})
def error(request):
    return render(request, 'error.html')
@login_required
@group_required('cliente')
def cliente_aggiungi(request):
    if UserCliente.objects.filter(user=request.user).exists():
        messages.error(request, "Hai già un cliente associato")
        return redirect("cliente")
    if request.method == 'POST':
        try:
            user_cliente = Cliente.objects.create(
                codice_fiscale=request.POST.get('codice_fiscale'),
                nome=request.POST.get('nome'),
                cognome=request.POST.get('cognome'),
                data_nascita=request.POST.get('data_nascita'),
                telefono=request.POST.get('telefono')
            )
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request,"cliente_aggiungi.html",{'error':errore})
        UserCliente.objects.create(
            user=request.user,
            cliente=user_cliente
        )
        messages.success(request, 'Cliente aggiunto con successo')
        return redirect('cliente')
    return render(request, 'cliente_aggiungi.html')
@login_required
@group_required('cliente')
def cliente_modifica(request):
    try:
        user_cliente=UserCliente.objects.get(user=request.user).cliente
    except UserCliente.DoesNotExist:
        messages.error(request, "Non hai un cliente associato")
        return redirect("cliente")
    if request.method == 'POST':
        user_cliente.codice_fiscale = request.POST.get('codice_fiscale')
        user_cliente.nome = request.POST.get('nome')
        user_cliente.cognome = request.POST.get('cognome')
        user_cliente.data_nascita = request.POST.get('data_nascita')
        user_cliente.telefono = request.POST.get('telefono')
        try:
            user_cliente.save()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "cliente_modifica.html", {'error': errore})
        messages.success(request, 'Cliente modificato con successo')
        return redirect('cliente')
    return render(request, 'cliente_modifica.html', {'cliente': user_cliente})
@login_required
@group_required('cliente')
def cliente_elimina(request):
    try:
        user_cliente = UserCliente.objects.get(user=request.user).cliente
    except UserCliente.DoesNotExist:
        messages.error(request, "Non hai un cliente associato")
        return redirect("cliente")
    if request.method == 'POST':
        try:
            user_cliente.delete()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "cliente_elimina.html", {'error': errore})
        messages.success(request, 'Cliente eliminato con successo')
        return redirect('cliente')
    return render(request, 'cliente_elimina.html', {'cliente': user_cliente})
@login_required
@group_required('cliente')
def cliente_visualizza(request):
    try:
        user_cliente = UserCliente.objects.get(user=request.user).cliente
    except UserCliente.DoesNotExist:
        messages.error(request, "Non hai un cliente associato")
        return redirect("cliente")
    return render(request, 'cliente_visualizza.html', {'cliente': user_cliente})
@login_required
@group_required('gestore_navi_crociera')
def crociera_aggiungi(request):
    itinerari=Itinerario.objects.all()
    if request.method == 'POST':
        try:
            itinerario_id = request.POST.get('id_itinerario')
            if itinerario_id:
                itinerarioOB = Itinerario.objects.get(pk=int(itinerario_id))
            else:
                itinerarioOB = None

            nave = Nave.objects.create(
                imo=request.POST.get('imo'),
                nome=request.POST.get('nome'),
                nazionalita=request.POST.get('nazionalita'),
                compagnia=request.POST.get('compagnia'),
                altezza=float(request.POST.get('altezza') or 0),
                lunghezza=float(request.POST.get('lunghezza') or 0),
                larghezza=float(request.POST.get('larghezza') or 0),
                capienza=int(request.POST.get('capienza') or 0),
                tipo="Crociera",
                peso_massimo=None,
                capacita=None,
                peso_occupato=0,
                volume_occupato=0,
                id_itinerario=itinerarioOB,
                latitudine=0,
                longitudine=0,
                direzione=0,
            )
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "crociera_aggiungi.html", {'error': errore})
        UserNave.objects.create(
            user=request.user,
            nave=nave
        )
        messages.success(request, 'Nave aggiunta con successo')
        return redirect('crociera')
    return render(request, 'crociera_aggiungi.html',{'itinerari':itinerari})
@login_required
@group_required('gestore_navi_crociera')
def crociera_modifica(request,imo):
    nave=get_object_or_404(Nave, imo=imo, usernave__user=request.user)
    itinerari=Itinerario.objects.all()
    if request.method == 'POST':
        nave.nome = request.POST.get('nome')
        nave.nazionalita = request.POST.get('nazionalita')
        nave.compagnia = request.POST.get('compagnia')
        nave.altezza = float(request.POST.get('altezza') or 0)
        nave.lunghezza = float(request.POST.get('lunghezza') or 0)
        nave.larghezza = float(request.POST.get('larghezza') or 0)
        nave.capienza = int(request.POST.get('capienza') or 0)
        itinerario_id = request.POST.get('id_itinerario')
        if itinerario_id:
            nave.id_itinerario = Itinerario.objects.get(pk=int(itinerario_id))
        else:
            nave.id_itinerario = None
        try:
            nave.save()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "crociera_modifica.html",{'error': errore})
        messages.success(request, 'Nave modificata con successo')
        return redirect('crociera')
    return render(request, 'crociera_modifica.html', {'nave': nave, 'itinerari':itinerari})
@login_required
@group_required('gestore_navi_crociera')
def crociera_elimina(request,imo):
    nave=get_object_or_404(Nave, imo=imo, usernave__user=request.user)
    if request.method == 'POST':
        try:
            nave.delete()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "crociera_elimina.html", {'error': errore})
        messages.success(request, 'Nave eliminata con successo')
        return redirect('crociera')
    return render(request, 'crociera_elimina.html', {'nave': nave})
@login_required
@group_required('gestore_navi_cargo')
def cargo_aggiungi(request):
    if request.method == 'POST':
        try:
            nave=Nave.objects.create(
                imo=request.POST.get('imo'),
                nome=request.POST.get('nome'),
                nazionalita=request.POST.get('nazionalita'),
                compagnia=request.POST.get('compagnia'),
                altezza=float(request.POST.get('altezza') or 0),
                lunghezza=float(request.POST.get('lunghezza') or 0),
                larghezza=float(request.POST.get('larghezza') or 0),
                peso_massimo=float(request.POST.get('peso_massimo') or 0),
                capacita=int(request.POST.get('capacita') or 0),
                peso_occupato=0,
                volume_occupato=0,
                capienza=None,
                latitudine=0,
                longitudine=0,
                direzione=0,
                tipo="Cargo",
            )
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "cargo_aggiungi.html",{'error':errore})
        UserNave.objects.create(
            user=request.user,
            nave=nave
        )
        messages.success(request, 'Nave aggiunta con successo')
        return redirect('cargo')
    return render(request, 'cargo_aggiungi.html')
@login_required
@group_required('gestore_navi_cargo')
def cargo_modifica(request,imo):
    nave=get_object_or_404(Nave, imo=imo, usernave__user=request.user)
    if request.method == 'POST':
        nave.nome = request.POST.get('nome')
        nave.nazionalita = request.POST.get('nazionalita')
        nave.compagnia = request.POST.get('compagnia')
        nave.altezza = float(request.POST.get('altezza') or 0)
        nave.lunghezza = float(request.POST.get('lunghezza') or 0)
        nave.larghezza = float(request.POST.get('larghezza') or 0)
        nave.peso_massimo = float(request.POST.get('peso_massimo') or 0)
        nave.capacita = int(request.POST.get('capacita') or 0)
        try:
            nave.save()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "cargo_modifica.html",{'error':errore})
        messages.success(request, 'Nave modificata con successo')
        return redirect('cargo')
    return render(request, 'cargo_modifica.html',{'nave':nave})
@login_required
@group_required('gestore_navi_cargo')
def cargo_elimina(request,imo):
    nave=get_object_or_404(Nave, imo=imo, usernave__user=request.user)
    if request.method == 'POST':
        try:
            nave.delete()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "cargo_elimina.html", {'error': errore})
        messages.success(request, 'Nave eliminata con successo')
        return redirect('cargo')
    return render(request, 'cargo_elimina.html', {'nave': nave})
@login_required
@group_required('gestore_magazzino')
def magazzino_aggiungi(request):
    if request.method == 'POST':
        try:
            mag = Magazzino.objects.create(
                nome=request.POST.get('nome'),
                localita=request.POST.get('localita'),
                tipo=request.POST.get('tipo'),
                capacita=float(request.POST.get('capacita') or 0),
            )
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "magazzino_aggiungi.html",{'error': errore})
        UserMagazzino.objects.create(
            user=request.user,
            nome_magazzino=mag.nome,
            localita_magazzino=mag.localita,
        )
        messages.success(request, 'Magazzino aggiunto con successo')
        return redirect('magazzino')
    return render(request, 'magazzino_aggiungi.html')
@login_required
@group_required('gestore_magazzino')
def magazzino_modifica(request,nome,localita):
    if not UserMagazzino.objects.filter(user=request.user, nome_magazzino=nome, localita_magazzino=localita).exists():
        messages.error(request, "Non sei autorizzato a modificare questo magazzino")
        return redirect('magazzino')
    sql = """
          SELECT  m.Nome, m.Localita, m.Tipo, m.Capacita, 1 AS id
          FROM Magazzino m
          WHERE m.Nome = %s
            AND m.Localita = %s 
          """
    mag = Magazzino.objects.raw(sql, [nome, localita])[0]
    if request.method == 'POST':
        tipo=request.POST.get('tipo')
        capacita=float(request.POST.get('capacita') or 0)
        with connection.cursor() as cursor:
            try:
                cursor.execute("""
                               UPDATE Magazzino
                               SET Tipo     = %s,
                                   Capacita = %s
                               WHERE Nome = %s
                                 AND Localita = %s
                               """, [
                                   tipo,
                                   capacita,
                                   nome,
                                   localita
                               ])
            except DatabaseError as e:
                errore = estrai_errore_db(e)
                return render(request, "magazzino_modifica.html",{'error': errore})
        if cursor.rowcount == 0:
            messages.error(request,'Magazzino non trovato')
            return redirect('magazzino')
        messages.success(request, 'Magazzino modificato con successo')
        return redirect('magazzino')
    return render(request, 'magazzino_modifica.html',{'magazzino':mag})
@login_required
@group_required('gestore_magazzino')
def magazzino_elimina(request,nome,localita):
    if not UserMagazzino.objects.filter(user=request.user, nome_magazzino=nome, localita_magazzino=localita).exists():
        messages.error(request, "Non sei autorizzato a eliminare questo magazzino")
        return redirect('magazzino')
    sql = """
          SELECT m.Nome, m.Localita, m.Tipo, m.Capacita, CONCAT(Nome, '', Localita) AS id
          FROM Magazzino m
          WHERE m.Nome = %s
            AND m.Localita = %s
          """
    mag = Magazzino.objects.raw(sql, [nome, localita])[0]
    if request.method == 'POST':
        with connection.cursor() as cursor:
            try:
                cursor.execute("""
                           DELETE FROM Magazzino
                           WHERE Nome = %s
                             AND Localita = %s
                           """, [nome, localita])
            except DatabaseError as e:
                errore = estrai_errore_db(e)
                return render(request, "magazzino_elimina.html",{'error': errore})
        if cursor.rowcount == 0:
            messages.error(request,'Magazzino non trovato')
            return redirect('magazzino')
        UserMagazzino.objects.filter(user=request.user, nome_magazzino=nome, localita_magazzino=localita).delete()
        messages.success(request, 'Magazzino eliminato con successo')
        return redirect('magazzino')
    return render(request, 'magazzino_elimina.html',{'magazzino':mag})
@login_required
@group_required('gestore_attracco_navi')
def banchina_aggiungi(request):
    if request.method == 'POST':
        try:
            ban = Banchina.objects.create(
                numero=int(request.POST.get('numero') or 0),
                settore=int(request.POST.get('settore') or 0),
                tipo=request.POST.get('tipo'),
                lunghezza=float(request.POST.get('lunghezza') or 0),
            )
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, "banchina_aggiungi.html",{'error':errore})
        UserBanchina.objects.create(
            user=request.user,
            numero_banchina=ban.numero,
            settore_banchina=ban.settore,
        )
        messages.success(request, 'Banchina aggiunta con successo')
        return redirect('banchina')
    return render(request, 'banchina_aggiungi.html')
@login_required
@group_required('gestore_attracco_navi')
def banchina_modifica(request,numero,settore):
    if not UserBanchina.objects.filter(user=request.user, numero_banchina=numero, settore_banchina=settore).exists():
        messages.error(request, "Non sei autorizzato a modificare questa banchina")
        return redirect('banchina')
    sql= """
        SELECT b.Numero, b.Settore, b.Tipo, b.Lunghezza, CONCAT(b.Numero, b.Settore) AS id
        FROM Banchina b
        WHERE b.Numero = %s
        AND b.Settore = %s
    """
    ban = Banchina.objects.raw(sql, [numero, settore])[0]
    if request.method == 'POST':
        tipo=request.POST.get('tipo')
        lunghezza=float(request.POST.get('lunghezza') or 0)
        with connection.cursor() as cursor:
                try:
                    cursor.execute("""
                                   UPDATE Banchina
                                   SET Tipo     = %s,
                                       Lunghezza = %s
                                   WHERE Numero = %s
                                     AND Settore = %s
                                   """, [tipo, lunghezza, numero, settore]
                    )
                except DatabaseError as e:
                    errore=estrai_errore_db(e)
                    return render(request, "banchina_modifica.html",{'error':errore})
                if cursor.rowcount == 0:
                    messages.error(request,'Banchina non trovata')
                    return redirect('banchina')
                messages.success(request, 'Banchina modificata con successo')
                return redirect('banchina')
    return render(request, 'banchina_modifica.html', {'banchina': ban})
@login_required
@group_required('gestore_attracco_navi')
def banchina_elimina(request,numero,settore):
    if not UserBanchina.objects.filter(user=request.user, numero_banchina=numero, settore_banchina=settore).exists():
        messages.error(request, "Non sei autorizzato a eliminare questa banchina")
        return redirect('banchina')
    sql = """
          SELECT b.Numero, b.Settore, b.Tipo, b.Lunghezza, CONCAT(b.Numero, b.Settore) AS id 
          FROM Banchina b 
          WHERE b.Numero = %s 
            AND b.Settore = %s 
         """
    ban = Banchina.objects.raw(sql, [numero, settore])[0]
    if request.method == 'POST':
        with connection.cursor() as cursor:
            try:
                cursor.execute("""
                                DELETE FROM Banchina
                                WHERE Numero = %s
                                AND Settore = %s
                                """, [numero, settore])
            except DatabaseError as e:
                errore=estrai_errore_db(e)
                return render(request, "banchina_elimina.html",{'error':errore})
            if cursor.rowcount == 0:
                messages.error(request,'Banchina non trovata')
                return redirect('banchina')
            messages.success(request, 'Banchina eliminata con successo')
            return redirect('banchina')
    return render(request, 'banchina_elimina.html', {'banchina': ban})
@login_required
@group_required('gestore_attracco_navi')
def attracco(request):
    navi = Nave.objects.filter(numero_banchina__isnull=True, settore_banchina__isnull=True)
    banchine_per_tipo=defaultdict(list)
    banchine=Banchina.objects.raw("""SELECT Numero, Settore, Tipo, Lunghezza, CONCAT(Numero, Settore) AS id FROM Banchina""")
    for b in banchine:
        banchine_per_tipo[b.tipo].append(b)
    navi_con_banchine = []
    for nave in navi:
        navi_con_banchine.append({
            "nave": nave,
            "banchine": banchine_per_tipo.get(nave.tipo, [])
        })
    if request.method == 'POST':
        imo=request.POST.get('imo')
        valore=request.POST.get(f"banchina_{imo}")
        if valore:
            numero, settore = valore.split('|')
            try:
                updated = Nave.objects.filter(imo=imo).update(numero_banchina=int(numero), settore_banchina=int(settore))
                if updated == 0:
                    messages.error(request, 'Nave non trovata')
                    return redirect('attracco')
            except DatabaseError as e:
                errore = estrai_errore_db(e)
                messages.error(request, errore)
                return redirect('attracco')
            messages.success(request, 'Nave attraccata con successo')
            return redirect('attracco')
    return render(request, 'attracco.html', {'navi_con_banchine': navi_con_banchine})
@login_required
@group_required('gestore_attracco_navi')
def attracco_visualizza(request):
    navi=Nave.objects.raw("""
        SELECT DISTINCT n.*
        FROM Nave n
        JOIN core_userbanchina ub ON
        n.numero_banchina = ub.numero_banchina AND n.settore_banchina = ub.settore_banchina
        WHERE ub.user_id = %s
    """,[request.user.id])
    if request.method == 'POST':
        imo=request.POST.get('imo')
        try:
            Nave.objects.filter(imo=imo).update(numero_banchina=None, settore_banchina=None)
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            messages.error(request, errore)
            return redirect('attracco_visualizza')
        messages.success(request, 'Nave disattraccata con successo')
        return redirect('attracco_visualizza')
    return render(request, 'attracco_visualizza.html',{'navi': navi})
@login_required
@group_required('gestore_navi_cargo')
def container(request, imo):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato a visualizzare i container su questa nave")
        return redirect('cargo')
    container_navi = Container.objects.filter(imo_id=imo)
    return render(request, 'container.html', {'imo': imo, 'container_navi': container_navi})
@login_required
@group_required('gestore_navi_cargo')
def container_aggiungi(request, imo):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato ad aggiungere container su questa nave")
        return redirect('cargo')
    if request.method == 'POST':
        try:
            Container.objects.create(
                id=request.POST.get('id'),
                dimensione=int(request.POST.get('dimensione') or 0),
                peso=0,
                marchio=request.POST.get('marchio'),
                imo_id=imo,
            )
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "container_aggiungi.html",{'imo': imo, 'error':errore})
        messages.success(request, 'Container aggiunto con successo')
        return redirect('container', imo=imo)
    return render(request, 'container_aggiungi.html', {'imo': imo})
@login_required
@group_required('gestore_navi_cargo')
def container_modifica(request, container_id):
    if not Container.objects.filter(id=container_id, imo__usernave__user=request.user).exists():
        messages.error(request, "Non sei autorizzato a modificare questo container")
        return redirect('cargo')
    c = Container.objects.get(id=container_id)
    navi = Nave.objects.filter(usernave__user=request.user)
    if request.method == 'POST':
        try:
            c.dimensione = int(request.POST.get('dimensione') or 0)
            c.marchio = request.POST.get('marchio')
            c.imo_id = request.POST.get('imo')
            c.save()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "container_modifica.html",{'container' : c, 'navi': navi, 'error': errore})
        messages.success(request, 'Container modificato con successo')
        return redirect('container', imo=c.imo_id)
    return render(request, 'container_modifica.html', {'container': c, 'navi': navi})
@login_required
@group_required('gestore_navi_cargo')
def container_elimina(request, container_id):
    if not Container.objects.filter(id=container_id, imo__usernave__user=request.user).exists():
        messages.error(request, "Non sei autorizzato ad eliminare questo container")
        return redirect('cargo')
    c = Container.objects.get(id=container_id)
    if request.method == 'POST':
        imo = c.imo_id
        try:
            c.delete()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "container_elimina.html",{'container': c, 'error': errore})
        messages.success(request, 'Container eliminato con successo')
        return redirect('container', imo=imo)
    return render(request, 'container_elimina.html', {'container': c})
@login_required
@group_required('gestore_navi_cargo')
def merce(request, container_id):
    if not Container.objects.filter(id=container_id, imo__usernave__user=request.user).exists():
        messages.error(request, "Non sei autorizzato ad accedere a questa merce")
        return redirect('cargo')
    m = Merce.objects.filter(id_container=container_id)
    return render(request, 'merce.html', {'container_id': container_id, 'merce': m})
@login_required
@group_required('gestore_navi_cargo')
def merce_aggiungi(request, container_id):
    if not Container.objects.filter(id=container_id, imo__usernave__user=request.user).exists():
        messages.error(request, "Non sei autorizzato ad aggiungere merce a questo container")
        return redirect('cargo')
    if request.method == 'POST':
        try:
            Merce.objects.create(
                sscc=request.POST.get('sscc'),
                peso=float(request.POST.get('peso') or 0),
                paese=request.POST.get('paese'),
                genere=request.POST.get('genere'),
                id_container_id=container_id,
            )
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "merce_aggiungi.html",{'container_id': container_id,'error': errore})
        messages.success(request, 'Merce aggiunta con successo')
        return redirect('merce', container_id=container_id)
    return render(request, 'merce_aggiungi.html', {'container_id': container_id})
@login_required
@group_required('gestore_navi_cargo')
def merce_modifica(request, sscc):
    if not Merce.objects.filter(sscc=sscc, id_container__imo__usernave__user=request.user).exists():
        messages.error(request, "Non sei autorizzato a modificare questa merce")
        return redirect('cargo')
    m = Merce.objects.get(sscc=sscc)
    c = Container.objects.filter(imo__usernave__user = request.user)
    if request.method == 'POST':
        try:
            m.peso = float(request.POST.get('peso') or 0)
            m.paese = request.POST.get('paese')
            m.genere = request.POST.get('genere')
            m.id_container_id=request.POST.get('id_container')
            m.save()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "merce_modifica.html",{'merce' : m, 'container' : c, 'error': errore})
        messages.success(request, 'Merce modificata con successo')
        return redirect('merce', container_id=m.id_container_id)
    return render(request, 'merce_modifica.html', {'merce': m, 'container' : c})
@login_required
@group_required('gestore_navi_cargo')
def merce_elimina(request, sscc):
    if not Merce.objects.filter(sscc=sscc, id_container__imo__usernave__user=request.user).exists():
        messages.error(request, "Non sei autorizzato ad eliminare questa merce")
        return redirect('cargo')
    m = Merce.objects.get(sscc=sscc)
    if request.method == 'POST':
        container_id=m.id_container_id
        try:
            m.delete()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "merce_elimina.html",{'merce': m, 'error': errore})
        messages.success(request, 'Merce eliminata con successo')
        return redirect('merce', container_id=container_id)
    return render(request, 'merce_elimina.html', {'merce': m})
@login_required
@group_required('gestore_magazzino')
def stoccaggio(request, nome, localita):
    if not UserMagazzino.objects.filter(nome_magazzino=nome, localita_magazzino=localita, user=request.user).exists():
        messages.error(request, "Non sei autorizzato ad accedere a questo magazzino")
        return redirect('magazzino')
    m=Merce.objects.filter(stoccaggio__nome_magazzino=nome, stoccaggio__localita_magazzino=localita)
    return render(request, 'stoccaggio.html', {'nome': nome, 'localita': localita, 'merce': m})
@login_required
@group_required('gestore_magazzino')
def stoccaggio_aggiungi(request, nome, localita):
    if not UserMagazzino.objects.filter(nome_magazzino=nome, localita_magazzino=localita, user=request.user).exists():
        messages.error(request, "Non sei autorizzato ad aggiungere merce a questo magazzino")
        return redirect('magazzino')
    mag = Magazzino.objects.raw("""SELECT m.Nome, m.Localita, m.Tipo, 1 AS id  FROM Magazzino m WHERE Nome = %s AND Localita = %s""", [nome, localita])[0]
    m = Merce.objects.filter(stoccaggio__isnull = True, genere=mag.tipo)
    if request.method == 'POST':
        selezionate = request.POST.getlist('merci')
        if not selezionate:
            return render(request, 'stoccaggio_aggiungi.html', {'nome': nome, 'localita': localita, 'merce': m, 'error': 'Nessuna merce selezionata'})
        for sscc in selezionate:
            try:
                Stoccaggio.objects.create(
                    sscc_id=sscc,
                    nome_magazzino=nome,
                    localita_magazzino=localita,
                )
            except DatabaseError as e:
                errore=estrai_errore_db(e)
                return render(request, 'stoccaggio_aggiungi.html', {'nome': nome, 'localita': localita, 'merce': m, 'error': errore})
        messages.success(request, 'Merci aggiunte con successo')
        return redirect('stoccaggio', nome=nome, localita=localita)
    return render(request, 'stoccaggio_aggiungi.html', {'nome': nome, 'localita': localita, 'merce': m})
@login_required
@group_required('gestore_magazzino')
def stoccaggio_modifica(request, sscc):
    query = """
            SELECT s.SSCC, s.Nome_magazzino, s.Localita_magazzino, 1 AS id
            FROM Stoccaggio s
                     JOIN core_usermagazzino um
                          ON s.Nome_magazzino = um.nome_magazzino
                              AND s.Localita_magazzino = um.localita_magazzino
            WHERE s.SSCC = %s
              AND um.user_id = %s
            """
    res = list(Stoccaggio.objects.raw(query,[sscc, request.user.id]))
    if not res:
        messages.error(request, "Non sei autorizzato a modificare questa merce")
        return redirect('magazzino')
    me = Merce.objects.get(sscc=sscc)
    s = Stoccaggio.objects.get(sscc_id=sscc)
    query = """ 
        SELECT m.Nome, m.Localita, 1 AS id
        FROM Magazzino m
        JOIN core_usermagazzino um ON m.Nome = um.nome_magazzino AND m.Localita = um.localita_magazzino
        WHERE um.user_id = %s AND m.Tipo = %s
    """
    mag = list(Magazzino.objects.raw(query, [request.user.id, me.genere]))
    if request.method == 'POST':
        selezionata = request.POST.get('magazzino')
        if not selezionata:
            return render(request, 'stoccaggio_modifica.html', {'stoccaggio': s, 'magazzini': mag, 'error': 'Nessun magazzino selezionato'})
        nome, localita = selezionata.split('|')
        valid = any(
            m.nome == nome and m.localita == localita
            for m in mag
        )
        if not valid:
            messages.error(request, "Magazzino non valido")
            return redirect('magazzino')
        try:
            Stoccaggio.objects.filter(sscc_id=sscc).update(nome_magazzino=nome, localita_magazzino=localita)
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, 'stoccaggio_modifica.html', {'sscc': sscc, 'magazzini': mag, 'error': errore})
        messages.success(request, 'Merce modificata con successo')
        return redirect('stoccaggio', nome=nome, localita=localita)
    return render(request, 'stoccaggio_modifica.html', {'sscc': sscc, 'magazzini': mag, 'stoccaggio': s})
@login_required
@group_required('gestore_magazzino')
def stoccaggio_elimina(request, sscc):
    query = """
            SELECT s.SSCC, s.Nome_magazzino, s.Localita_magazzino, 1 AS id
            FROM Stoccaggio s
                     JOIN core_usermagazzino um
                          ON s.Nome_magazzino = um.nome_magazzino
                              AND s.Localita_magazzino = um.localita_magazzino
            WHERE s.SSCC = %s AND um.user_id = %s
    """
    res = list(Stoccaggio.objects.raw(query, [sscc, request.user.id]))
    if not res:
        messages.error(request, "Non sei autorizzato a rimuovere questa merce")
        return redirect('magazzino')
    s = Stoccaggio.objects.get(sscc_id=sscc)
    if request.method == 'POST':
        try:
            s.delete()
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request, 'stoccaggio_elimina.html', {'sscc': sscc, 'error': errore})
        messages.success(request, 'Merce eliminata con successo')
        return redirect('stoccaggio', nome=s.nome_magazzino, localita=s.localita_magazzino)
    return render(request, 'stoccaggio_elimina.html', {'sscc': sscc, 'nome': s.nome_magazzino, 'localita': s.localita_magazzino})
@login_required
@group_required('gestore_navi_crociera')
def stanza(request, imo):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato ad accedere a questa nave")
        return redirect('crociera')
    stanze = Stanza.objects.raw("""SELECT s.IMO, s.Numero, s.Classe, s.Tipo, 1 AS id FROM Stanza s WHERE s.IMO = %s""", [imo])
    return render(request, 'stanza.html', {'imo': imo, 'stanze': stanze})
@login_required
@group_required('gestore_navi_crociera')
def stanza_aggiungi(request, imo):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato ad aggiungere stanza a questa nave")
        return redirect('crociera')
    if request.method == 'POST':
        try:
            with connection.cursor() as cursor:
                cursor.execute("""INSERT INTO Stanza (IMO, Numero, Classe, Tipo) VALUES (%s, %s, %s, %s)""", [imo, request.POST.get('numero'), request.POST.get('classe'), request.POST.get('tipo')])
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "stanza_aggiungi.html",{'imo': imo, 'error': errore})
        messages.success(request, 'Stanza aggiunta con successo')
        return redirect('stanza', imo=imo)
    return render(request, 'stanza_aggiungi.html', {'imo': imo})
@login_required
@group_required('gestore_navi_crociera')
def stanza_modifica(request,imo,numero):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato a modificare questa stanza")
        return redirect('crociera')
    s = Stanza.objects.raw("""SELECT s.IMO, s.Numero, s.Classe, s.Tipo, 1 AS id FROM Stanza s WHERE IMO = %s AND Numero = %s""", [imo, numero])[0]
    if request.method == 'POST':
        try:
            with connection.cursor() as cursor:
                cursor.execute("""UPDATE Stanza SET Classe = %s, Tipo = %s WHERE IMO = %s AND Numero = %s""", [request.POST.get('classe'), request.POST.get('tipo'), imo, numero])
        except DatabaseError as e:
                errore = estrai_errore_db(e)
                return render(request, "stanza_modifica.html",{'stanza' : s, 'error': errore})
        messages.success(request, 'Stanza modificata con successo')
        return redirect('stanza', imo=imo)
    return render(request, 'stanza_modifica.html', {'stanza':s})
@login_required
@group_required('gestore_navi_crociera')
def stanza_elimina(request, imo, numero):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato ad eliminare questa stanza")
        return redirect('crociera')
    if request.method == 'POST':
        try:
            with connection.cursor() as cursor:
                cursor.execute("""DELETE FROM Stanza WHERE IMO = %s AND Numero = %s""", [imo, numero])
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, "stanza_elimina.html",{'imo': imo, 'numero': numero, 'error': errore})
        messages.success(request, 'Stanza eliminata con successo')
        return redirect('stanza', imo=imo)
    return render(request, 'stanza_elimina.html', {'imo': imo, 'numero': numero})
@login_required
@group_required('gestore_navi_crociera')
def itinerario(request):
    itinerari_modificabili = (
        Itinerario.objects
        .filter(useritinerario__user=request.user)
        .distinct()
    )
    itinerari_non_modificabili = (
        Itinerario.objects
        .exclude(useritinerario__user=request.user)
        .distinct()
    )
    def aggiungi_tappe(lista_itinerari):
        for it in lista_itinerari:
            with connection.cursor() as cursor:
                cursor.execute("""
                    SELECT Tappa
                    FROM Tappe_itinerario
                    WHERE ID_itinerario = %s
                """, [it.id])
                rows = cursor.fetchall()
            it.tappe = [r[0] for r in rows]
    aggiungi_tappe(itinerari_modificabili)
    aggiungi_tappe(itinerari_non_modificabili)
    return render(request, 'itinerario.html', {
        'itinerari_modificabili': itinerari_modificabili,
        'itinerari_non_modificabili': itinerari_non_modificabili,
    })
@login_required
@group_required('gestore_navi_crociera')
def itinerario_aggiungi(request):

    if request.method == 'POST':

        try:
            it = Itinerario.objects.create(
                nome=request.POST.get('nome'),
                data_inizio=request.POST.get('data_inizio'),
                data_fine=request.POST.get('data_fine'),
                prezzo=float(request.POST.get('prezzo') or 0),
            )

            tappe_raw = request.POST.get('tappe', '')

            lista_tappe = [
                t.strip()
                for t in tappe_raw.split(',')
                if t.strip()
            ]

            with connection.cursor() as cursor:
                for tappa in lista_tappe:
                    cursor.execute("""
                        INSERT INTO Tappe_itinerario(ID_itinerario, Tappa)
                        VALUES (%s, %s)
                    """, [it.id, tappa])
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'itinerario_aggiungi.html', {'error': errore})
        UserItinerario.objects.create(user=request.user, itinerario=it)
        messages.success(request, 'Itinerario aggiunto con successo')
        return redirect('itinerario')

    return render(request, 'itinerario_aggiungi.html')
@login_required
@group_required('gestore_navi_crociera')
def itinerario_modifica(request, itinerario_id):

    if not UserItinerario.objects.filter(
        user=request.user,
        itinerario_id=itinerario_id
    ).exists():

        messages.error(request, "Non sei autorizzato a modificare questo itinerario")
        return redirect('itinerario')

    it = Itinerario.objects.get(id=itinerario_id)

    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT Tappa
            FROM Tappe_itinerario
            WHERE ID_itinerario = %s
        """, [itinerario_id])

        rows = cursor.fetchall()

    tappe = [r[0] for r in rows]

    if request.method == 'POST':

        try:

            it.nome = request.POST.get('nome')
            it.data_inizio = request.POST.get('data_inizio')
            it.data_fine = request.POST.get('data_fine')
            it.prezzo = float(request.POST.get('prezzo') or 0)

            it.save()

            nuove_tappe = request.POST.get('tappe', '')

            lista_tappe = [
                t.strip()
                for t in nuove_tappe.split(',')
                if t.strip()
            ]

            with connection.cursor() as cursor:

                cursor.execute("""
                    DELETE FROM Tappe_itinerario
                    WHERE ID_itinerario = %s
                """, [itinerario_id])

                for tappa in lista_tappe:

                    cursor.execute("""
                        INSERT INTO Tappe_itinerario(ID_itinerario, Tappa)
                        VALUES (%s, %s)
                    """, [itinerario_id, tappa])


        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'itinerario_modifica.html', {
                'itinerario': it,
                'tappe': ", ".join(tappe),
                'error': errore
            })
        messages.success(request, 'Itinerario modificato con successo')
        return redirect('itinerario')
    return render(request, 'itinerario_modifica.html', {
        'itinerario': it,
        'tappe': ", ".join(tappe)
    })
@login_required
@group_required('gestore_navi_crociera')
def itinerario_elimina(request, itinerario_id):

    if not UserItinerario.objects.filter(
        user=request.user,
        itinerario_id=itinerario_id
    ).exists():
        messages.error(request, "Non sei autorizzato a eliminare questo itinerario")
        return redirect('itinerario')

    it = Itinerario.objects.get(id=itinerario_id)

    if request.method == 'POST':

        try:
            UserItinerario.objects.filter(itinerario_id=itinerario_id).delete()
            it.delete()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'itinerario_elimina.html', {
                'itinerario': it,
                'error': errore
            })
        messages.success(request, 'Itinerario eliminato con successo')
        return redirect('itinerario')
    return render(request, 'itinerario_elimina.html', {
        'itinerario': it
    })
@login_required
@group_required('gestore_navi_crociera')
def guida(request):
    guide_modificabili = UserGuida.objects.filter(user=request.user)
    guide_non_modificabili = UserGuida.objects.exclude(user=request.user)
    # arricchisco ogni guida con le lingue
    guide_mod = []
    guide_non_mod = []
    with connection.cursor() as cursor:
        for ug in guide_modificabili:
            guida = ug.guida
            cursor.execute("""
                SELECT Lingua, Livello
                FROM Lingue_guida
                WHERE Codice_fiscale = %s
            """, [guida.codice_fiscale])
            lingue = cursor.fetchall()
            guide_mod.append({
                'guida': guida,
                'lingue': lingue
            })
        for ug in guide_non_modificabili:
            guida = ug.guida
            cursor.execute("""
                SELECT Lingua, Livello
                FROM Lingue_guida
                WHERE Codice_fiscale = %s
            """, [guida.codice_fiscale])
            lingue = cursor.fetchall()
            guide_non_mod.append({
                'guida': guida,
                'lingue': lingue
            })
    return render(request, 'guida.html', {
        'guide_mod': guide_mod,
        'guide_non_mod': guide_non_mod
    })
@login_required
@group_required('gestore_navi_crociera')
def guida_aggiungi(request):
    itinerari = UserItinerario.objects.filter(user=request.user)
    if request.method == 'POST':
        try:
            g = Guida.objects.create(
                codice_fiscale=request.POST.get('codice_fiscale'),
                nome=request.POST.get('nome'),
                cognome=request.POST.get('cognome'),
                data_nascita=request.POST.get('data_nascita'),
                numero_licensa=int(request.POST.get('numero_licensa') or 0),
                stipendio=float(request.POST.get('stipendio') or 0),
                data_assunzione=request.POST.get('data_assunzione'),
                valutazione=float(request.POST.get('valutazione') or 0),
                id_itinerario_id=request.POST.get('id_itinerario') or None
            )

            lingue_raw = request.POST.get('lingue', '')

            lingue_list = [
                x.strip()
                for x in lingue_raw.split(',')
                if x.strip()
            ]

            with connection.cursor() as cursor:
                for item in lingue_list:

                    if ':' not in item:
                        continue

                    lingua, livello = item.split(':', 1)

                    cursor.execute("""
                        INSERT INTO Lingue_guida(Codice_fiscale, Lingua, Livello)
                        VALUES (%s, %s, %s)
                    """, [g.codice_fiscale, lingua.strip(), livello.strip()])
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'guida_aggiungi.html', {
                'error': errore,
                'itinerari': itinerari
            })
        UserGuida.objects.create(user=request.user, guida=g)
        messages.success(request, 'Guida aggiunta con successo')
        return redirect('guida')

    return render(request, 'guida_aggiungi.html', {
        'itinerari': itinerari
    })
@login_required
@group_required('gestore_navi_crociera')
def guida_modifica(request, codice_fiscale):

    # controllo autorizzazione (stesso pattern degli altri moduli)
    if not UserGuida.objects.filter(
        user=request.user,
        guida_id=codice_fiscale
    ).exists():
        messages.error(request, "Non sei autorizzato a modificare questa guida")
        return redirect('guida')

    g = Guida.objects.get(codice_fiscale=codice_fiscale)

    itinerari = UserItinerario.objects.filter(user=request.user)

    # recupero lingue attuali
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT Lingua, Livello
            FROM Lingue_guida
            WHERE Codice_fiscale = %s
        """, [codice_fiscale])
        lingue_db = cursor.fetchall()

    lingue_str = ", ".join([f"{l[0]}:{l[1]}" for l in lingue_db])

    if request.method == 'POST':

        try:
            g.nome = request.POST.get('nome')
            g.cognome = request.POST.get('cognome')
            g.data_nascita = request.POST.get('data_nascita')
            g.numero_licensa = int(request.POST.get('numero_licensa') or 0)
            g.stipendio = float(request.POST.get('stipendio') or 0)
            g.data_assunzione = request.POST.get('data_assunzione')
            g.valutazione = float(request.POST.get('valutazione') or 0)
            g.id_itinerario_id = request.POST.get('id_itinerario') or None

            g.save()

            # aggiorno lingue (strategia semplice: delete + insert)
            with connection.cursor() as cursor:
                cursor.execute("""
                    DELETE FROM Lingue_guida
                    WHERE Codice_fiscale = %s
                """, [codice_fiscale])

                lingue_raw = request.POST.get('lingue', '')

                lingue_list = [
                    x.strip()
                    for x in lingue_raw.split(',')
                    if x.strip()
                ]

                for item in lingue_list:

                    if ':' not in item:
                        continue

                    lingua, livello = item.split(':', 1)

                    cursor.execute("""
                        INSERT INTO Lingue_guida(Codice_fiscale, Lingua, Livello)
                        VALUES (%s, %s, %s)
                    """, [codice_fiscale, lingua.strip(), livello.strip()])


        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'guida_modifica.html', {
                'guida': g,
                'itinerari': itinerari,
                'lingue': lingue_str,
                'error': errore
            })
        messages.success(request, 'Guida modificata con successo')
        return redirect('guida')
    return render(request, 'guida_modifica.html', {
        'guida': g,
        'itinerari': itinerari,
        'lingue': lingue_str
    })
@login_required
@group_required('gestore_navi_crociera')
def guida_elimina(request, codice_fiscale):

    if not UserGuida.objects.filter(
        user=request.user,
        guida_id=codice_fiscale
    ).exists():
        messages.error(request, "Non sei autorizzato a eliminare questa guida")
        return redirect('guida')

    g = Guida.objects.get(codice_fiscale=codice_fiscale)

    if request.method == 'POST':
        try:
            UserGuida.objects.filter(guida_id=codice_fiscale).delete()
            g.delete()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'guida_elimina.html', {
                'guida': g,
                'error': errore
            })

        messages.success(request, 'Guida eliminata con successo')
        return redirect('guida')

    return render(request, 'guida_elimina.html', {
        'guida': g
    })
@login_required
@group_required('cliente')
def prenotazione(request):

    if not UserCliente.objects.filter(user=request.user).exists():
        messages.error(request, "Devi inserire i tuoi dati per poter effettuare una prenotazione")
        return redirect('cliente')

    itinerari = list(Itinerario.objects.all())

    #  prendo tutte le tappe in una sola query
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT ID_itinerario, Tappa
            FROM Tappe_itinerario
        """)
        rows = cursor.fetchall()

    tappe_map = {}
    for id_itin, tappa in rows:
        tappe_map.setdefault(id_itin, []).append(tappa)

    # attacco le tappe agli oggetti itinerario
    for i in itinerari:
        i.tappe = tappe_map.get(i.id, [])

    risultati = None

    if request.method == 'POST':
        itinerari_ids = request.POST.getlist('itinerari')
        classi = request.POST.getlist('classe')
        tipi = request.POST.getlist('tipo')
        data_inizio = request.POST.get('data_inizio')
        data_fine = request.POST.get('data_fine')

        query = """
            SELECT DISTINCT
            s.IMO,
            n.Nome AS NomeNave,
            s.Numero,
            s.Classe,
            s.Tipo,
            1 AS id
            FROM Stanza s
            JOIN Nave n ON s.IMO = n.IMO
            JOIN Itinerario i ON n.ID_itinerario = i.ID
            WHERE 1=1
        """

        params = []

        if itinerari_ids:
            query += " AND i.ID IN ({})".format(','.join(['%s'] * len(itinerari_ids)))
            params.extend(itinerari_ids)

        if classi:
            query += " AND s.Classe IN ({})".format(','.join(['%s'] * len(classi)))
            params.extend(classi)

        if tipi:
            query += " AND s.Tipo IN ({})".format(','.join(['%s'] * len(tipi)))
            params.extend(tipi)

        if data_inizio and data_fine:
            query += """
                AND NOT EXISTS (
                    SELECT 1
                    FROM Prenotazione p
                    WHERE p.IMO = s.IMO
                      AND p.Numero = s.Numero
                      AND (
                            p.Data_inizio <= %s
                        AND p.Scadenza >= %s
                      )
                )
            """
            params.append(data_fine)
            params.append(data_inizio)

        with connection.cursor() as cursor:
            cursor.execute(query, params)
            columns = [col[0] for col in cursor.description]
            risultati = [dict(zip(columns, row)) for row in cursor.fetchall()]

    return render(request, 'prenotazione.html', {
        'itinerari': itinerari,
        'risultati': risultati
    })
@login_required
@group_required('cliente')
def prenotazione_aggiungi(request, imo, numero):
    if not UserCliente.objects.filter(user=request.user).exists():
        messages.error(request, "Devi inserire i tuoi dati per poter effettuare una prenotazione")
        return redirect('cliente')
    i = Nave.objects.get(imo=imo).id_itinerario
    s = list(Stanza.objects.raw("""SELECT s.IMO, s.Numero, s.Classe, s.Tipo, 1 AS id FROM Stanza s WHERE s.IMO = %s AND s.Numero = %s""", [imo, numero]))[0]
    if s.tipo == "Singola" :
        prezzo = i.prezzo
    else:
        prezzo = i.prezzo * 2
    if request.method == 'POST':
        try:
            Prenotazione.objects.create(
                imo=imo,
                numero=numero,
                codice_fiscale=UserCliente.objects.get(user=request.user).cliente,
                data_inizio=request.POST.get('data_inizio'),
                scadenza=request.POST.get('data_fine'),
                servizio_guida=1 if request.POST.get('servizio_guida') else 0,
            )
        except DatabaseError as e:
            errore=estrai_errore_db(e)
            return render(request,'prenotazione_aggiungi.html',{'itinerario': i,'stanza': s,'prezzo': prezzo,'error': errore })
        return redirect('prenotazione_visualizza')
    return render(request, 'prenotazione_aggiungi.html', {'itinerario': i, 'stanza': s, 'prezzo': prezzo})
@login_required
@group_required('cliente')
def prenotazione_visualizza(request):

    if not UserCliente.objects.filter(user=request.user).exists():
        messages.error(request, "Devi inserire i tuoi dati per poter effettuare una prenotazione")
        return redirect('cliente')

    query = """
        SELECT 
            p.ID,
            p.IMO AS imo,
            n.Nome AS NomeNave,
            p.Numero AS numero,
            p.Data_inizio AS data_inizio,
            p.Scadenza AS scadenza,
            p.Servizio_guida AS servizio_guida
        FROM Prenotazione p
        JOIN Nave n ON p.IMO = n.IMO
        WHERE p.Codice_fiscale = %s
    """

    with connection.cursor() as cursor:
        cursor.execute(query, [UserCliente.objects.get(user=request.user).cliente.codice_fiscale])
        columns = [col[0] for col in cursor.description]
        prenotazioni = [
            dict(zip(columns, row))
            for row in cursor.fetchall()
        ]

    return render(request, 'prenotazione_visualizza.html', {
        'prenotazioni': prenotazioni
    })
@login_required
@group_required('cliente')
def prenotazione_modifica(request, id_prenotazione):
    if not Prenotazione.objects.filter(id=id_prenotazione, codice_fiscale=UserCliente.objects.get(user=request.user).cliente).exists():
        messages.error(request, "Non sei autorizzato a modificare questa prenotazione")
        return redirect('prenotazione')
    p = Prenotazione.objects.get(id=id_prenotazione)
    if request.method == 'POST':
        try:
            p.data_inizio = request.POST.get('data_inizio')
            p.scadenza = request.POST.get('data_fine')
            p.servizio_guida = 1 if request.POST.get('servizio_guida') else 0
            p.save()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'prenotazione_modifica.html', {'prenotazione': p, 'error': errore})
        except DataError:
            return render(request, 'prenotazione_modifica.html', {'prenotazione': p, 'error': 'Dati non validi'})
        messages.success(request, 'Prenotazione modificata con successo')
        return redirect('prenotazione_visualizza')
    return render(request, 'prenotazione_modifica.html', {'prenotazione': p})
@login_required
@group_required('cliente')
def prenotazione_elimina(request, id_prenotazione):
    if not Prenotazione.objects.filter(id=id_prenotazione, codice_fiscale=UserCliente.objects.get(user=request.user).cliente).exists():
        messages.error(request, "Non sei autorizzato a eliminare questa prenotazione")
        return redirect('prenotazione')
    p = Prenotazione.objects.get(id=id_prenotazione)
    if request.method == 'POST':
        try:
            p.delete()
        except DatabaseError as e:
            errore = estrai_errore_db(e)
            return render(request, 'prenotazione_elimina.html', {'prenotazione': p, 'error': errore})
        messages.success(request, 'Prenotazione eliminata con successo')
        return redirect('prenotazione_visualizza')
    return render(request, 'prenotazione_elimina.html', {'prenotazione': p})
@login_required
@group_required('gestore_navi_crociera')
def nave_prenotazione(request, imo):
    if not UserNave.objects.filter(user=request.user, nave__imo=imo).exists():
        messages.error(request, "Non sei autorizzato a vedere le prenotazioni questa nave")
        return redirect('crociera')
    p = Prenotazione.objects.filter(imo=imo)
    return render(request, 'nave_prenotazione.html', {'prenotazioni': p, 'imo':imo})
@login_required
def mappa_navi(request):
    navi = Nave.objects.all()
    data_navi = []
    for nave in navi:
        data_navi.append({
            'imo': nave.imo,
            'nome': nave.nome,
            'compagnia': nave.compagnia,
            'nazionalita': nave.nazionalita,
            'tipo': nave.tipo,
            'latitudine': nave.latitudine,
            'longitudine': nave.longitudine,
            'direzione' : nave.direzione
        })
    status = SystemStatus.objects.first()
    return render(request, 'mappa_navi.html', {'navi_json': data_navi, 'last_update': status.last_update if status else None})