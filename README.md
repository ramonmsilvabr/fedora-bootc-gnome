# Aviso

Essa imagem é para uso pessoal, mas você pode usar ela como template para construir a sua se precisar.

# Objetivo

Possibilitar o uso do Fedora Linux sem se basear na distribuição oficial, com ajustes específicos para meu caso de uso e com o mínimo de pacotes possível.

# Informações

- Imagem base: `quay.io/fedora/fedora-bootc` **Fedora Linux (bootc)**.
- Versão distribuída atualmente: 44 (Forty Four)
- Compositor: Mutter 50.x
- Ambiente Desktop: GNOME Shell 50.x
- Firmware: Fechados/distribuídos pelo linux-firmware
- Drivers: Open Source pelo Mesa3D
- Módulos carregados: **ntsync**

## Flatpaks

- Remove o remoto Fedora uma vez após a instalação
- Instala o repositório do [Flathub](https://flathub.org/).
- Apenas dois flatpaks são inclusos:
    - **Mozilla Firefox**: Permite navegar na Web para fazer as instalações
    - **Save Desktop**: Restaura todos os outros apps.

# Instalação

Puxe a imagem e compile pelo podman, após terminar faça o switch via bootc.

```
sudo podman pull quay.io/fedora/fedora-bootc:44
sudo podman build --build-arg FEDORA_VERSION=44 --build-arg IMAGE_VERSION=$(date +%Y%m%d).0 -t fedora-bootc-gnome . -f builds/default/Containerfile
sudo bootc switch --transport containers-storage localhost/fedora-bootc-gnome:latest
```
## ISOs

Disponíveis uma vez por lançamento na aba Releases