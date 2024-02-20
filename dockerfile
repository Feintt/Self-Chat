# Usar la imagen oficial de Elixir para compilar tu aplicación
FROM elixir:latest AS build

# Instalar Phoenix
RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix archive.install hex phx_new --force

# Crear y definir el directorio de trabajo de la aplicación
WORKDIR /app
COPY . /app

# Install inotify-tools for live reload during development
# Update package listings, avoid prompts by using -y, and clean up after install to keep the image size down
RUN apt-get update && \
  apt-get install -y inotify-tools && \
  rm -rf /var/lib/apt/lists/*

# Instalar las dependencias de la aplicación
RUN mix deps.get
RUN mix deps.compile

# Compilar la aplicación
RUN mix compile

# Compilar los assets (si los tienes, para aplicaciones API puedes omitir este paso)
# RUN cd assets && npm install && npm run deploy
# RUN mix phx.digest

# RUN mix ecto.setup

# Correr las migraciones y luego la aplicación
CMD ["mix", "phx.server"]
