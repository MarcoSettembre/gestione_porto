"""
URL configuration for porto project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from porto import views
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.register, name='index'),
    path('login',views.login_view, name='login'),
    path('homepage',views.homepage, name='homepage'),
    path('logout',views.logout_view, name='logout'),
    path('cliente',views.cliente, name='cliente'),
    path('attracco', views.attracco, name='attracco'),
    path('cargo', views.cargo, name='cargo'),
    path('crociera', views.crociera, name='crociera'),
    path('magazzino', views.magazzino, name='magazzino'),
    path('error', views.error, name='error'),
]
