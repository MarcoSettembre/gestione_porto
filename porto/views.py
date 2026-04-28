from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

def register(request):
    if request.method != "POST":
        return render(request, 'index.html')
    username=request.POST.get('username')
    password=request.POST.get('password')
    password2=request.POST.get('password2')
    if password != password2:
        return render(request,'index.html', {'error': "Le password non combaciano"})
    if User.objects.filter(username=username).exists():
        return render(request, 'index.html', {'error': "Lo username inserito già esiste"})
    User.objects.create_user(username=username, password=password)
    return render(request, 'login.html', {'success': "Registrazione effettuata con successo"})
def login_view(request):
    if request.method != "POST":
        return render(request, 'login.html')
    username = request.POST.get('username')
    password = request.POST.get('password')
    user = authenticate(username=username, password=password)
    if user is not None:
        login(request,user)
        return render(request, 'homepage.html', {'username': username})
    return render(request, 'login.html', {'error': "Credenziali non valide"})
@login_required
def homepage(request):
    return render(request, 'homepage.html')
def logout_view(request):
    logout(request)
    return render(request, 'login.html', {'success': "Logout effettuato con successo"})