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
    path('logout',views.logout_view, name='logout'),
    path('modifica_password', views.modifica_password, name='modifica_password'),
    path('cliente',views.cliente, name='cliente'),
    path('banchina', views.banchina, name='banchina'),
    path('cargo', views.cargo, name='cargo'),
    path('crociera', views.crociera, name='crociera'),
    path('magazzino', views.magazzino, name='magazzino'),
    path('error', views.error, name='error'),
    path('cliente/aggiungi', views.cliente_aggiungi, name='cliente_aggiungi'),
    path('cliente/modifica', views.cliente_modifica, name='cliente_modifica'),
    path('cliente/elimina', views.cliente_elimina, name='cliente_elimina'),
    path('cliente/visualizza', views.cliente_visualizza, name='cliente_visualizza'),
    path('crociera/aggiungi', views.crociera_aggiungi, name='crociera_aggiungi'),
    path('crociera/modifica/<str:imo>', views.crociera_modifica, name='crociera_modifica'),
    path('crociera/elimina/<str:imo>', views.crociera_elimina, name='crociera_elimina'),
    path('cargo/aggiungi', views.cargo_aggiungi, name='cargo_aggiungi'),
    path('cargo/modifica/<str:imo>', views.cargo_modifica, name='cargo_modifica'),
    path('cargo/elimina/<str:imo>', views.cargo_elimina, name='cargo_elimina'),
    path('magazzino/aggiungi', views.magazzino_aggiungi, name='magazzino_aggiungi'),
    path('magazzino/modifica/<str:nome>/<str:localita>', views.magazzino_modifica, name='magazzino_modifica'),
    path('magazzino/elimina/<str:nome>/<str:localita>', views.magazzino_elimina, name='magazzino_elimina'),
    path('banchina/aggiungi', views.banchina_aggiungi, name='banchina_aggiungi'),
    path('banchina/modifica/<int:numero>/<int:settore>', views.banchina_modifica, name='banchina_modifica'),
    path('banchina/elimina/<int:numero>/<int:settore>', views.banchina_elimina, name='banchina_elimina'),
    path('banchina/attracco', views.attracco, name='attracco'),
    path('banchina/attracco_visualizza', views.attracco_visualizza, name='attracco_visualizza'),
    path('cargo/container/<str:imo>', views.container, name='container'),
    path('cargo/container/aggiungi/<str:imo>', views.container_aggiungi, name='container_aggiungi'),
    path('cargo/container/modifica/<str:container_id>', views.container_modifica, name='container_modifica'),
    path('cargo/container/elimina/<str:container_id>', views.container_elimina, name='container_elimina'),
    path('cargo/merce/<str:container_id>', views.merce, name='merce'),
    path('cargo/merce/aggiungi/<str:container_id>', views.merce_aggiungi, name='merce_aggiungi'),
    path('cargo/merce/modifica/<str:sscc>', views.merce_modifica, name='merce_modifica'),
    path('cargo/merce/elimina/<str:sscc>', views.merce_elimina, name='merce_elimina'),
    path('magazzino/stoccaggio/modifica/<str:sscc>', views.stoccaggio_modifica, name='stoccaggio_modifica'),
    path('magazzino/stoccaggio/elimina/<str:sscc>', views.stoccaggio_elimina, name='stoccaggio_elimina'),
    path('magazzino/stoccaggio/<str:nome>/<str:localita>', views.stoccaggio, name='stoccaggio'),
    path('magazzino/stoccaggio/aggiungi/<str:nome>/<str:localita>', views.stoccaggio_aggiungi, name='stoccaggio_aggiungi'),
    path('crociera/stanza/<str:imo>', views.stanza, name='stanza'),
    path('crociera/stanza/aggiungi/<str:imo>', views.stanza_aggiungi, name='stanza_aggiungi'),
    path('crociera/stanza/modifica/<str:imo>/<int:numero>', views.stanza_modifica, name='stanza_modifica'),
    path('crociera/stanza/elimina/<str:imo>/<int:numero>', views.stanza_elimina, name='stanza_elimina'),
    path('crociera/itinerario', views.itinerario, name='itinerario'),
    path('crociera/itinerario/aggiungi', views.itinerario_aggiungi, name='itinerario_aggiungi'),
    path('crociera/itinerario/modifica/<int:itinerario_id>', views.itinerario_modifica, name='itinerario_modifica'),
    path('crociera/itinerario/elimina/<int:itinerario_id>', views.itinerario_elimina, name='itinerario_elimina'),
    path('crociera/guida', views.guida, name='guida'),
    path('crociera/guida/aggiungi', views.guida_aggiungi, name='guida_aggiungi'),
    path('crociera/guida/modifica/<str:codice_fiscale>', views.guida_modifica, name='guida_modifica'),
    path('crociera/guida/elimina/<str:codice_fiscale>', views.guida_elimina, name='guida_elimina'),
    path('cliente/prenotazione', views.prenotazione, name='prenotazione'),
    path('cliente/prenotazione/aggiungi/<str:imo>/<int:numero>', views.prenotazione_aggiungi, name='prenotazione_aggiungi'),
    path('cliente/prenotazione/visualizza', views.prenotazione_visualizza, name='prenotazione_visualizza'),
    path('cliente/prenotazione/modifica/<int:id_prenotazione>', views.prenotazione_modifica, name='prenotazione_modifica'),
    path('cliente/prenotazione/elimina/<int:id_prenotazione>', views.prenotazione_elimina, name='prenotazione_elimina'),
]
