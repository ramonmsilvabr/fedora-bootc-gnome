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

(em construção)

# Instalação

Puxe a imagem e compile pelo podman, após terminar faça o switch via bootc.

```
sudo podman pull quay.io/fedora/fedora-bootc:44
sudo podman build --build-arg FEDORA_VERSION=44 -t fedora-bootc-gnome . -f builds/default/Containerfile
sudo bootc switch --transport containers-storage localhost/fedora-bootc-gnome:latest
```
## ISOs

(em construção)

