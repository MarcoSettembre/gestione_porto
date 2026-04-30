from django.contrib import admin

# Register your models here.
from django.contrib import admin
from .models import UserCliente, UserBanchina, UserMagazzino, UserNave

admin.site.register(UserCliente)
admin.site.register(UserBanchina)
admin.site.register(UserMagazzino)
admin.site.register(UserNave)