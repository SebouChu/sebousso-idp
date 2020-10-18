# SebouSSO - IdP

Identity Provider dans l'écosystème SebouSSO

## Certificat

### Génération

```bash
openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout 2030_sebousso_saml.key -out 2030_sebousso_saml.crt
```

### Fingerprint

```bash
openssl x509 -in 2030_sebousso_saml.crt -noout -sha256 -fingerprint
```
