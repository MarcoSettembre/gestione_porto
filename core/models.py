# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
from django.contrib.auth.models import User

class Banchina(models.Model):
    numero = models.IntegerField(db_column='Numero')
    settore = models.IntegerField(db_column='Settore')
    tipo = models.CharField(db_column='Tipo', max_length=8)
    lunghezza = models.FloatField(db_column='Lunghezza')

    class Meta:
        managed = True
        db_table = 'Banchina'
        unique_together = (('numero', 'settore'),)

class Cliente(models.Model):
    codice_fiscale = models.CharField(db_column='Codice_fiscale', primary_key=True, max_length=16)  # Field name made lowercase.
    nome = models.CharField(db_column='Nome', max_length=100)  # Field name made lowercase.
    cognome = models.CharField(db_column='Cognome', max_length=100)  # Field name made lowercase.
    data_nascita = models.DateField(db_column='Data_nascita')  # Field name made lowercase.
    telefono = models.CharField(db_column='Telefono', max_length=20, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Cliente'


class Container(models.Model):
    id = models.CharField(db_column='ID', primary_key=True, max_length=11)  # Field name made lowercase.
    dimensione = models.IntegerField(db_column='Dimensione')  # Field name made lowercase.
    peso = models.FloatField(db_column='Peso')  # Field name made lowercase.
    marchio = models.CharField(db_column='Marchio', max_length=100)  # Field name made lowercase.
    imo = models.ForeignKey('Nave', models.DO_NOTHING, db_column='IMO', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Container'


class Guida(models.Model):
    codice_fiscale = models.CharField(db_column='Codice_fiscale', primary_key=True, max_length=16)  # Field name made lowercase.
    nome = models.CharField(db_column='Nome', max_length=100)  # Field name made lowercase.
    cognome = models.CharField(db_column='Cognome', max_length=100)  # Field name made lowercase.
    data_nascita = models.DateField(db_column='Data_nascita')  # Field name made lowercase.
    numero_licensa = models.IntegerField(db_column='Numero_licensa', unique=True)  # Field name made lowercase.
    stipendio = models.DecimalField(db_column='Stipendio', max_digits=20, decimal_places=2)  # Field name made lowercase.
    data_assunzione = models.DateField(db_column='Data_assunzione')  # Field name made lowercase.
    valutazione = models.FloatField(db_column='Valutazione')  # Field name made lowercase.
    id_itinerario = models.ForeignKey('Itinerario', models.DO_NOTHING, db_column='ID_itinerario', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Guida'


class Itinerario(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    data_inizio = models.DateField(db_column='Data_inizio')  # Field name made lowercase.
    data_fine = models.DateField(db_column='Data_fine')  # Field name made lowercase.
    nome = models.CharField(db_column='Nome', max_length=100, blank=True, null=True)  # Field name made lowercase.
    prezzo = models.DecimalField(db_column='Prezzo', max_digits=20, decimal_places=2)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Itinerario'


class LingueGuida(models.Model):
    codice_fiscale = models.ForeignKey('Guida', models.DO_NOTHING, db_column='Codice_fiscale')
    lingua = models.CharField(db_column='Lingua', max_length=50)
    livello = models.CharField(db_column='Livello', max_length=6)

    class Meta:
        managed = True
        db_table = 'Lingue_guida'
        unique_together = (('codice_fiscale', 'lingua'),)


class Magazzino(models.Model):
    nome = models.CharField(db_column='Nome', max_length=100)
    localita = models.CharField(db_column='Localita', max_length=100)
    tipo = models.CharField(db_column='Tipo', max_length=100)
    capacita = models.FloatField(db_column='Capacita')

    class Meta:
        managed = True
        db_table = 'Magazzino'
        unique_together = (('nome', 'localita'),)


class Merce(models.Model):
    sscc = models.CharField(db_column='SSCC', primary_key=True, max_length=18)  # Field name made lowercase.
    peso = models.FloatField(db_column='Peso')  # Field name made lowercase.
    paese = models.CharField(db_column='Paese', max_length=50)  # Field name made lowercase.
    genere = models.CharField(db_column='Genere', max_length=100)  # Field name made lowercase.
    id_container = models.CharField(db_column='ID_container', max_length=11, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Merce'


class Nave(models.Model):
    imo = models.CharField(db_column='IMO', primary_key=True, max_length=7)  # Field name made lowercase.
    nome = models.CharField(db_column='Nome', max_length=100)  # Field name made lowercase.
    nazionalita = models.CharField(db_column='Nazionalita', max_length=100)  # Field name made lowercase.
    compagnia = models.CharField(db_column='Compagnia', max_length=100)  # Field name made lowercase.
    altezza = models.FloatField(db_column='Altezza')  # Field name made lowercase.
    lunghezza = models.FloatField(db_column='Lunghezza')  # Field name made lowercase.
    larghezza = models.FloatField(db_column='Larghezza')  # Field name made lowercase.
    peso_massimo = models.FloatField(db_column='Peso_massimo', blank=True, null=True)  # Field name made lowercase.
    capacita = models.IntegerField(db_column='Capacita', blank=True, null=True)  # Field name made lowercase.
    peso_occupato = models.FloatField(db_column='Peso_occupato', blank=True, null=True)  # Field name made lowercase.
    volume_occupato = models.IntegerField(db_column='Volume_occupato', blank=True, null=True)  # Field name made lowercase.
    capienza = models.IntegerField(db_column='Capienza', blank=True, null=True)  # Field name made lowercase.
    tipo = models.CharField(db_column='Tipo', max_length=8)  # Field name made lowercase.
    numero_banchina = models.ForeignKey(Banchina, models.DO_NOTHING, db_column='Numero_banchina', blank=True, null=True)  # Field name made lowercase.
    settore_banchina = models.ForeignKey(Banchina, models.DO_NOTHING, db_column='Settore_banchina', related_name='nave_settore_banchina_set', blank=True, null=True)  # Field name made lowercase.
    id_itinerario = models.ForeignKey(Itinerario, models.DO_NOTHING, db_column='ID_itinerario', blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Nave'


class Prenotazione(models.Model):
    id = models.AutoField(db_column='ID', primary_key=True)  # Field name made lowercase.
    imo = models.ForeignKey('Stanza', models.DO_NOTHING, db_column='IMO')  # Field name made lowercase.
    numero = models.ForeignKey('Stanza', models.DO_NOTHING, db_column='Numero', related_name='prenotazione_numero_set')  # Field name made lowercase.
    codice_fiscale = models.ForeignKey(Cliente, models.DO_NOTHING, db_column='Codice_fiscale')  # Field name made lowercase.
    data_inizio = models.DateField(db_column='Data_inizio')  # Field name made lowercase.
    scadenza = models.DateField(db_column='Scadenza')  # Field name made lowercase.
    servizio_guida = models.IntegerField(db_column='Servizio_guida')  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Prenotazione'


class Stanza(models.Model):
    imo = models.ForeignKey('Nave', models.DO_NOTHING, db_column='IMO')
    numero = models.IntegerField(db_column='Numero')
    classe = models.CharField(db_column='Classe', max_length=7)
    tipo = models.CharField(db_column='Tipo', max_length=12)

    class Meta:
        managed = True
        db_table = 'Stanza'
        unique_together = (('imo', 'numero'),)


class Stoccaggio(models.Model):
    sscc = models.OneToOneField(Merce, models.DO_NOTHING, db_column='SSCC', primary_key=True)  # Field name made lowercase.
    nome_magazzino = models.ForeignKey(Magazzino, models.DO_NOTHING, db_column='Nome_magazzino')  # Field name made lowercase.
    localita_magazzino = models.ForeignKey(Magazzino, models.DO_NOTHING, db_column='Localita_magazzino', related_name='stoccaggio_localita_magazzino_set')  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'Stoccaggio'


class TappeItinerario(models.Model):
    id_itinerario = models.ForeignKey('Itinerario', models.DO_NOTHING, db_column='ID_itinerario')
    tappa = models.CharField(db_column='Tappa', max_length=100)

    class Meta:
        managed = True
        db_table = 'Tappe_itinerario'
        unique_together = (('id_itinerario', 'tappa'),)
class UserCliente(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    cliente = models.OneToOneField(Cliente, on_delete=models.CASCADE)
    def __str__(self):
        return f"{self.user.username} -> Cliente {self.cliente.codice_fiscale} {self.cliente.nome} {self.cliente.cognome}"
class UserNave(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    nave = models.ForeignKey(Nave, on_delete=models.CASCADE)
    class Meta:
        unique_together = (('user', 'nave'),)
    def __str__(self):
        return f"{self.user.username} -> Nave {self.nave.imo} {self.nave.nome}"
class UserMagazzino(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    magazzino = models.ForeignKey(Magazzino, on_delete=models.CASCADE)
    class Meta:
        unique_together = (('user', 'magazzino'),)
    def __str__(self):
        return f"{self.user.username} -> Magazzino {self.magazzino.nome} {self.magazzino.localita}"
class UserBanchina(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    numero_banchina = models.IntegerField(default=0)
    settore_banchina = models.IntegerField(default=0)
    class Meta:
        unique_together = (('user', 'numero_banchina', 'settore_banchina'),)
    def __str__(self):
        return f"{self.user.username} -> Banchina {self.numero_banchina} {self.settore_banchina}"