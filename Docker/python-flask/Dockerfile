FROM python:3.8-slim-buster
#WORKDIR /python-docker #Default
RUN mkdir /app
RUN groupadd -r user && useradd -r -g user user
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
COPY . .
USER user
EXPOSE 5000
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]