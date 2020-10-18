# SebouSSO - IdP

Identity Provider dans l'écosystème SebouSSO

## Écosystème

L'écosystème SebouSSO est constituée de plusieurs application Ruby on Rails :
- **IdP** : Identity Provider qui fournit identité et rôle aux autres applications via SAML
- **[Blog](https://github.com/SebouChu/sebousso-blog)** : Service Provider, blog d'articles
- **Video** : Service Provider, plateforme vidéo

## Certificat

### Génération

```bash
openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout 2030_sebousso_saml.key -out 2030_sebousso_saml.crt
```

### Fingerprint

```bash
openssl x509 -in 2030_sebousso_saml.crt -noout -sha256 -fingerprint
```
