# Sum+

Mobile application that seeks to promote the practice and learning of basic mathematics, allowing to practice arithmetic operations. It is intended primarily for elementary school students of educational institutions, but it's suitable for anybody who wants to exercise their maths.

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/800498bd-8488-454b-9c6e-c16ff1658039" alt="Quest" height="600">

## Views

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/82a7503c-660c-4400-a01c-503aba7648f7" alt="First page" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/d828648e-ee7e-41b3-ab14-5077b5119dce" alt="Login" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/050db9e7-8ef0-4fc0-8329-168c95e20645" alt="Signup" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/409d9a87-a146-4c47-96ee-e27f2c7e5d40" alt="Home" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/800498bd-8488-454b-9c6e-c16ff1658039" alt="Quest" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/d5136d22-b5fd-486a-abdf-355a32caf9f2" alt="Results" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/4b73ff2b-21c6-46a6-9b35-c51111a9370e" alt="Profile" height="400">
<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/1d7a009e-17e5-42ab-84cb-13d5f0b7456e" alt="History" height="400">

## Getting Started

### Releases (Android)

In the [Releases](https://github.com/leovergaramarq/sum-plus/) section, you will find APK file for download and installation. Since this installation is through an APK, Android will prompt an alert when attempting to install it. In that case, just proceed to install it.

### Running Source code and Mount Backend

This is an optional guide to use the login and signup features, as well as saaving your progress in the backend. However, you can avoid this by selecting the Guest Mode in the app login screen (your progress will be saved locally).

#### Prerrequisites

- [Flutter](https://docs.flutter.dev/get-started/install).

#### Steps

Mounting the backend means running a server-side application that this app uses for both sign up and login. That is the [Authentication Server](https://github.com/augustosalazar/p_auth_server), a dockerized application.

Even though you can host the Authentication Server anywhere, you can follow the next steps to host it temporarily in [Play with Docker](https://labs.play-with-docker.com) for simplicity:

1. Clone this repository.

       git clone https://github.com/leovergaramarq/sum-plus.git

2. Install the necessary dependencies (run in the project root folder).

       flutter pub get

3. Go to [Play with Docker](https://labs.play-with-docker.com).

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/29b57635-32d7-49fc-bbdb-2f991bf2bbec" alt="Play with Docker image">

4. Create an account in DockerHub if you don't have one, and sign in with this account.

5. Start.

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/dc7be8ce-0fff-4b36-8c70-170f10a6fbeb" alt="Play with Docker image">

6. Create an instance.

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/fa261599-2ba8-4b62-ac4b-8890dee7ef95" alt="Play with Docker image">

7. Run these commands in the terminal.

```bash
git clone https://github.com/augustosalazar/p_auth_server.git

docker build --tag authi p_auth_server

docker run -d -it -p 8000:8000 authi
```

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/c4f2aa8d-6e79-4db5-a9ac-b6f8366f33e4" alt="Play with Docker image">

8. Select port 8000 or "OPEN PORT" for a custom port. A new tab will open.

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/37fd79ad-bca3-450c-8bf5-1db1bb7bb809" alt="Play with Docker image">

9. In the opened tab, copy the URL.

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/32af6759-9c98-4d40-82a0-1d76d0d7fe49" alt="Play with Docker image">

10. Go to the file `/lib/data/repositories/auth_authserver_repository.dart` and replace the URL in variable `_baseUrl` (approximately line 11) with the copied value in the previous step. Make sure not to put the final slash (/).

<img src="https://github.com/leovergaramarq/sum-plus/assets/73978713/6549b809-a7f3-4677-99e1-7a16a69a3a98" alt="Replacing _baseUrl">

11. Run the app with your preferred development environment (Android Studio, Visual Studio Code, etc.) or with the command (run in the project root folder):

        flutter run

## Acknowledgements

- [Retool API Generator](https://retool.com/api-generator).
- [Authentication server](https://github.com/augustosalazar/p_auth_server) by [Augusto Salazar](https://github.com/augustosalazar) gracias profe :D
