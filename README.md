# Sistema ICTIOLÓGICO – Monitoreo de Fauna Acuática

Aplicación móvil y API para la captura, almacenamiento y sincronización de información biológica obtenida durante eventos de muestreo ictiológico.

El sistema fue diseñado para operar tanto en línea como fuera de línea (Offline First), permitiendo registrar información en campo sin acceso a internet y sincronizar posteriormente los datos con un servidor central.

---

# Características Principales

## Gestión de Salidas de Campo

* Crear eventos de muestreo.
* Editar eventos.
* Finalizar eventos.
* Eliminar eventos sin ocurrencias asociadas.
* Asociar nombre de proyecto.
* Registrar observaciones generales.

---

## Registro de Ocurrencias

* Registro de individuos observados o capturados.
* Asociación automática con especies del catálogo.
* Registro de variables biológicas.
* Captura automática de coordenadas GPS.
* Obtención de latitud, longitud y altitud.
* Asociación automática con la estación de monitoreo más cercana.
* Funcionamiento offline.

---

## Mediciones Fisicoquímicas

El sistema permite registrar:

* Oxígeno disuelto
* pH
* Conductividad
* Turbidez
* Temperatura
* TDS
* Transparencia Secchi
* Salinidad
* ORP
* Alcalinidad
* Dureza
* Amonio
* Fósforo
* Nitratos
* Nitritos
* Fosfatos
* Clorofila-a
* SST
* Coliformes fecales

---

## Evidencias

### Evidencias de Ocurrencias

* Fotografías asociadas a individuos registrados.
* Almacenamiento local y sincronización posterior.

### Evidencias de Salidas

* Fotografías generales del evento de muestreo.
* Almacenamiento local y sincronización posterior.

---

## Trabajo Offline

La aplicación puede operar sin conexión a internet utilizando SQLite.

Los registros creados localmente son sincronizados automáticamente cuando existe conectividad.

---

# Arquitectura General

```text
Flutter Mobile App
        │
        ▼
SQLite Local Database
        │
        ▼
SyncService
        │
        ▼
FastAPI REST API
        │
        ▼
PostgreSQL
```

---

# Arquitectura del Proyecto

## Backend

```text
backend_app_ictiologica/

app/
├── api/
├── models/
├── repositories/
├── schemas/
├── services/
├── utils/

storage/
├── evidencias/
└── salida_evidencias/

Scripts_db/
└── db_tesis.sql
```

---

## Frontend

```text
frontend_app_ictiologica/

lib/
├── app/
├── core/
├── features/
├── shared/
└── main.dart
```

---

# Tecnologías Utilizadas

## Backend

| Tecnología        | Versión |
| ----------------- | ------- |
| Python            | 3.13    |
| FastAPI           | 0.136.1 |
| Uvicorn           | 0.46.0  |
| SQLAlchemy        | 2.0.49  |
| PostgreSQL        | 17.x    |
| Pydantic          | 2.13.4  |
| JWT (python-jose) | 3.5.0   |
| Passlib           | 1.7.4   |
| BCrypt            | 4.0.1   |
| psycopg2-binary   | 2.9.12  |
| python-dotenv     | 1.2.2   |

---

## Frontend

| Tecnología             | Versión |
| ---------------------- | ------- |
| Flutter                | 3.41.9  |
| Dart                   | 3.11.5  |
| Provider               | 6.1.5+1 |
| Dio                    | 5.9.2   |
| SQLite (sqflite)       | 2.4.2   |
| Geolocator             | 13.0.4  |
| Connectivity Plus      | 6.1.5   |
| Image Picker           | 1.2.1   |
| Flutter Secure Storage | 9.2.4   |
| Path Provider          | 2.1.5   |
| UUID                   | 4.5.3   |
| Intl                   | 0.20.2  |

---

# Dependencias Backend

```bash
fastapi
uvicorn
sqlalchemy
psycopg2-binary
pydantic
pydantic-settings
python-dotenv
python-jose
passlib
bcrypt
python-multipart
email-validator
```

Instalación:

```bash
pip install -r requirements.txt
```

---

# Dependencias Frontend

```bash
provider
dio
sqflite
path
path_provider
connectivity_plus
geolocator
image_picker
flutter_secure_storage
uuid
intl
```

Instalación:

```bash
flutter pub get
```

---

# Funcionalidades de Geolocalización

Al registrar una ocurrencia:

1. Se obtiene la ubicación GPS.
2. Se registran:

   * Latitud
   * Longitud
   * Altitud
3. El backend identifica automáticamente la estación más cercana.
4. Se almacena el identificador de la estación en PostgreSQL.

Las estaciones son administradas exclusivamente por el sistema.

El usuario no puede:

* Crear estaciones.
* Editar estaciones.
* Eliminar estaciones.

---

# Persistencia Local

Base de datos:

```text
ictiologia_app.db
```

Tablas locales:

* species
* salidas
* ocurrencias
* mediciones
* evidencias
* salida_evidencia

---

# Estrategia Offline

Cada registro local contiene:

```text
sync_status
is_deleted
updated_at_local
```

Estados:

```text
pending
synced
```

---

# Sincronización

Componente responsable:

```text
SyncService
```

Orden de sincronización:

```text
1. Salidas
2. Ocurrencias
3. Mediciones
4. Evidencias
```

Este orden garantiza la integridad referencial.

---

# Seguridad

Autenticación mediante JWT.

Formato:

```http
Authorization: Bearer <token>
```

Los tokens se almacenan mediante:

```text
Flutter Secure Storage
```

---

# Evidencias

Las imágenes se almacenan utilizando el formato:

```text
CODIGO_OCURRENCIA_FAAAAMMDD_HHMMSS.ext
```

Ejemplo:

```text
OCC001_F20260618_H141530.jpg
```

Donde:

* F = Fecha
* H = Hora

---

# Instalación Rápida

## Backend

Clonar repositorio:

```bash
git clone <URL_BACKEND>
cd backend_app_ictiologica
```

Crear entorno virtual:

```bash
python -m venv venv
```

Activar entorno virtual:

Windows:

```bash
venv\Scripts\activate
```

macOS:

```bash
source venv/bin/activate
```

Instalar dependencias:

```bash
pip install -r requirements.txt
```

Crear archivo `.env`:

```env
DATABASE_URL=postgresql://postgres:123456@localhost:5432/ictiologia
SECRET_KEY=clave_secreta
ACCESS_TOKEN_EXPIRE_MINUTES=60
```

Ejecutar servidor:

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000
```

Swagger:

```text
http://localhost:8000/docs
```

---

## Base de Datos

Crear base de datos:

```sql
CREATE DATABASE ictiologia;
```

Ejecutar:

```text
Scripts_db/db_tesis.sql
```

Crear rol inicial:

```sql
INSERT INTO roles (
    nombre_rol,
    descripcion
)
VALUES (
    'Investigador',
    'Se puede dejar null'
);
```

Cargar datos iniciales:

* Roles
* Especies
* Estaciones

---

## Frontend

Clonar repositorio:

```bash
git clone <URL_FRONTEND>
cd frontend_app_ictiologica
```

Instalar dependencias:

```bash
flutter pub get
```

---

# Configuración de IP

Cuando el proyecto se despliegue en otro computador o servidor debe actualizarse la IP del backend en los siguientes archivos:

```text
lib/app/core/network/api_client.dart

lib/features/evidencias/presentation/pages/evidencia_create_page.dart

lib/features/evidencias/presentation/pages/detail_page.dart

lib/features/ocurrencias/presentation/pages/ocurrencia_create_page.dart
```

Ejemplo:

```dart
const String baseUrl =
"http://192.168.1.100:8000/api/v1";
```

Obtener IP local:

Windows:

```bash
ipconfig
```

macOS:

```bash
ifconfig
```

Buscar la dirección IPv4 del equipo donde se ejecuta el backend.

---

# Ejecución de la Aplicación

```bash
flutter run
```

---

# Flujo General del Sistema

```text
Usuario
 ↓
Crear salida
 ↓
Registrar ocurrencia
 ↓
Capturar GPS
 ↓
Asignar estación automáticamente
 ↓
Registrar medición
 ↓
Adjuntar evidencia
 ↓
Sincronizar
 ↓
PostgreSQL
```

---

# Verificación Final

Backend:

```text
http://localhost:8000/docs
```

Frontend:

```bash
flutter run
```

Pruebas recomendadas:

1. Registrar usuario.
2. Iniciar sesión.
3. Crear salida.
4. Crear ocurrencia.
5. Obtener ubicación GPS.
6. Asociar estación automáticamente.
7. Registrar medición.
8. Registrar evidencia.
9. Probar funcionamiento offline.
10. Ejecutar sincronización.

---

# Licencia

Proyecto académico desarrollado para apoyar procesos de monitoreo ictiológico y gestión de información biológica en estudios ambientales.
