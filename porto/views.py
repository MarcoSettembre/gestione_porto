from django.contrib import messages
from django.shortcuts import render, redirect
from django.contrib.auth.models import User, Group
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

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
    return render(request, 'login.html', {'success': "Registrazione effettuata con successo"})
def login_view(request):
    if request.user.is_authenticated and request.user is not None:
        role = get_user_role(request.user)
        if role != 'admin':
            return redirect_by_role(request)
        return render(request, 'login.html')
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
    if(get_user_role(request.user) == 'admin'):
        return render(request, 'homepage.html')
    return redirect('error')
@login_required
def logout_view(request):
    logout(request)
    messages.success(request, 'Logout effettuato con successo')
    return redirect('login')
@login_required
def cliente(request):
    role=get_user_role(request.user)
    if(role == 'cliente' or role == 'admin'):
        return render(request, 'cliente.html')
    return redirect('error')
@login_required
def attracco(request):
    role = get_user_role(request.user)
    if(role == 'gestore_attracco_navi' or role == 'admin'):
        return render(request, 'attracco.html')
    return redirect('error')
@login_required
def cargo(request):
    role = get_user_role(request.user)
    if(role == 'gestore_navi_cargo' or role == 'admin'):
        return render(request, 'cargo.html')
    return redirect('error')
@login_required
def crociera(request):
    role = get_user_role(request.user)
    if(role == 'gestore_navi_crociera' or role == 'admin'):
        return render(request, 'crociera.html')
    return redirect('error')
@login_required
def magazzino(request):
    role = get_user_role(request.user)
    if(role == 'gestore_magazzino' or role == 'admin'):
        return render(request, 'magazzino.html')
    return redirect('error')
def error(request):
    return render(request, 'error.html')