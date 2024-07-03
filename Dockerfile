FROM python:3.9-alpine3.13
#(opcional, identifica quien lo creó)
LABEL maintainer 'leikcaro' 
#recom c/Python en docker, para que imprima errores directo
ENV PYTHONBUFFERED 1 
#copiamos dentro del container los archivos
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
#especificamos que cuando generemos un comando se corra dentro de all (pq ahi esta manage.py)
WORKDIR /app
#el puerto al cual estará expuesto el contenedor cuando este encendido
EXPOSE 8000

#un solo run para que no cree una imagen separada, se separan las lineas con \
#se supone no es necesario crear un venv con docker pero podria ser necesario, en este caso se deja
RUN python -m venv /py && \
/py/bin/pip install --upgrade pip && \
/py/bin/pip install -r /tmp/requirements.txt && \
#borra la carpeta tmp con el requirements.txt para que la imagen quede lo mas ligera posible
rm -rf /tmp && \
#otra buena practica, en vez de correr con el ROOT. No necesaria, pero si la app es vulnerada, el atacante no tiene todo, sino parte.
adduser \
    --disabled-password \
    --no-create-home \
    django-user

ENV PATH="/py/bin:$PATH"
USER django-user