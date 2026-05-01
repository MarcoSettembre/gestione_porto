from django.contrib import messages
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.models import Group
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from core.models import *
from django.db import IntegrityError, DataError

from porto.decorators import group_required


def get_user_role(user):
    return user.groups.all()[0].name
def redirect_by_role(request):
    role = get_user_role(request.user)
    if role == 'cliente':
        return redirect('cliente')
    elif role == 'gestore_attracco_navi':
        return redirect('attracco')
    elif role == 'gestore_navi_cargo':
        return redirect('cargo')
    elif role == 'gestore_navi_crociera':
        return redirect('crociera')
    elif role == 'gestore_magazzino':
        return redirect('magazzino')
    elif role == 'admin':
        return redirect('homepage')
    return redirect('')
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
    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
        return redirect_by_role(request)
    return render(request, 'login.html', {'error': "Credenziali non valide"})
@login_required
def homepage(request):
    return render(request, 'homepage.html')
@login_required
def logout_view(request):
    logout(request)
    messages.success(request, 'Logout effettuato con successo')
    return redirect('login')
@login_required
@group_required('cliente')
def cliente(request):
    return render(request, 'cliente.html')
@login_required
@group_required('gestore_attracco_navi')
def attracco(request):
    return render(request, 'attracco.html')
@login_required
@group_required('gestore_navi_cargo')
def cargo(request):
    return render(request, 'cargo.html')
@login_required
@group_required('gestore_navi_crociera')
def crociera(request):
    user_nave=UserNave.objects.filter(user=request.user).select_related('nave')
    return render(request, 'crociera.html', {'navi': user_nave})
@login_required
@group_required('gestore_magazzino')
def magazzino(request):
    return render(request, 'magazzino.html')
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
        except IntegrityError:
            return render(request,"cliente_aggiungi.html",{'error':"Vincolo non rispettato"})
        except DataError:
            return render(request,"cliente_aggiungi.html",{'error':"Dati non validi"})
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
        except IntegrityError:
            return render(request, "cliente_modifica.html", {'error': "Vincolo non rispettato"})
        except DataError:
            return render(request, "cliente_modifica.html", {'error': "Dati non validi"})
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
        user_cliente.delete()
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
                id_itinerario=itinerarioOB
            )
        except IntegrityError:
            return render(request, "crociera_aggiungi.html",{'error':"Vincolo non rispettato"})
        except DataError:
            return render(request, "crociera_aggiungi.html",{'error':"Dati non validi"})
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
        except IntegrityError:
            return render(request, "crociera_modifica.html",{'error':"Vincolo non rispettato"})
        except DataError:
            return render(request, "crociera_modifica.html",{'error':"Dati non validi"})
        messages.success(request, 'Nave modificata con successo')
        return redirect('crociera')
    return render(request, 'crociera_modifica.html', {'nave': nave, 'itinerari':itinerari})
@login_required
@group_required('gestore_navi_crociera')
def crociera_elimina(request,imo):
    nave=get_object_or_404(Nave, imo=imo, usernave__user=request.user)
    if request.method == 'POST':
        nave.delete()
        messages.success(request, 'Nave eliminata con successo')
        return redirect('crociera')
    return render(request, 'crociera_elimina.html', {'nave': nave})
