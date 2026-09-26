# fedora-bootc-gnome-ramon
Repositório de imagem customizada especificamente para uso do Fedora na estação de trabalho.

```
sudo podman build --build-arg FEDORA_VERSION=44 -t fedora-bootc-gnome-ramon . -f builds/default/Containerfile
```