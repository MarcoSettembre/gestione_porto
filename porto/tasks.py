from celery import shared_task
from django.conf import settings
from django.utils import timezone
from core.models import Nave, SystemStatus
import requests


@shared_task
def aggiorna_posizioni_navi():

    navi = Nave.objects.all()

    headers = {
        "Authorization": f"Bearer {settings.MYST_API_KEY}"
    }

    for nave in navi:

        try:

            url = (
                "https://api.myshiptracking.com/api/v2/vessel"
                f"?imo={nave.imo}"
            )

            risposta = requests.get(
                url,
                headers=headers,
                timeout=10
            )

            dati = risposta.json()

            print(dati)

            if (
                dati.get("status") == "success"
                and "data" in dati
            ):

                info = dati["data"]

                nave.latitudine = float(
                    info["lat"]
                )

                nave.longitudine = float(
                    info["lng"]
                )
                nave.direzione = float(
                    info["course"]
                )
                nave.save()
                SystemStatus.objects.update_or_create(
                    id=1,
                    defaults={"last_update": timezone.now()}
                )
                print(
                    f"{nave.nome} aggiornata"
                )

        except Exception as e:

            print(
                f"Errore {nave.nome}: {e}"
            )