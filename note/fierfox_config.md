Voici ta fiche complète en Markdown, prête à copier et à conserver dans un fichier `configuration-firefox-securite.md`.

Écriture

# 🔐 Configuration sécurisée de Firefox – Linux Mint

**Objectif :** disposer d'un navigateur renforcé, avec une bonne isolation des processus, une protection contre les sites malveillants et une meilleure confidentialité.

Niveau visé : protection élevée, sans réglages expérimentaux inutiles.

---

## 1\. Installation de Firefox

- Télécharger Firefox depuis le site officiel : [https://www.mozilla.org/firefox/linux/](<https://www.mozilla.org/firefox/linux/>)
- Privilégier une version officielle et maintenue.
- Éviter de mélanger les installations APT, Flatpak, Snap et archive Mozilla.
- Activer les mises à jour automatiques.
- Vérifier la version installée :

bash

```bash
firefox --version
```

Vérifier son emplacement :

bash

```bash
which firefox
```

---

## 2\. Protection contre le pistage

Dans :

`Paramètres → Vie privée et sécurité`

Configurer :

- Protection renforcée contre le pistage : **Stricte**.
- Bloquer les traqueurs intersites.
- Bloquer les cookies de pistage intersites.
- Bloquer les cryptomineurs.
- Bloquer les scripts de fingerprinting lorsque possible.

Attention : certains sites peuvent rencontrer des problèmes de fonctionnement avec le mode strict.

---

## 3\. Mode HTTPS uniquement

Dans :

`Paramètres → Vie privée et sécurité → Mode HTTPS uniquement`

Activer :

- HTTPS uniquement dans toutes les fenêtres.

Ne créer des exceptions que pour les sites réellement nécessaires et fiables.

---

## 4\. Protection contre les sites dangereux

Dans les paramètres de sécurité :

- Bloquer les contenus dangereux et trompeurs : ACTIVÉ.
- Bloquer les téléchargements dangereux : ACTIVÉ.
- Avertir en cas de logiciel indésirable : ACTIVÉ.
- Ne jamais désactiver la protection contre le phishing.

Conserver les listes de protection à jour.

---

## 5\. DNS sécurisé

Dans :

`Paramètres → Vie privée et sécurité → DNS via HTTPS`

Configuration recommandée :

- Protection : Protection accrue.
- Fournisseur : Cloudflare (1.1.1.1).

Le DNS sécurisé chiffre les requêtes DNS, mais ne garantit pas qu'un site soit fiable.

---

## 6\. Permissions des sites

| Permission | Configuration |
| --- | --- |
| Localisation | Demander |
| Caméra | Demander |
| Microphone | Demander |
| Notifications | Bloquer |
| Lecture automatique | Bloquer l'audio et la vidéo |
| Pop-ups | Bloquer |
| Installation de modules complémentaires | Demander |

Ne donner aucune permission inutile aux sites.

---

## 7\. Extensions

### Extension recommandée

**uBlock Origin**

[https://addons.mozilla.org/firefox/addon/ublock-origin/](<https://addons.mozilla.org/firefox/addon/ublock-origin/>)

Utilité :

- Bloquer les publicités.
- Bloquer les traqueurs.
- Bloquer de nombreux domaines malveillants connus.
- Réduire les scripts et contenus indésirables.

Limiter le nombre d'extensions installées.

Ne pas installer d'extensions provenant de sources inconnues.

---

## 8\. Gestion des téléchargements

Dans les paramètres généraux :

- Toujours demander où enregistrer les fichiers.
- Ne pas ouvrir automatiquement les fichiers téléchargés.
- Ne pas exécuter directement les fichiers inconnus.
- Vérifier la provenance des téléchargements.
- Ne pas lancer de scripts provenant de sites douteux.
- Ne pas exécuter d'AppImage sans vérifier sa provenance.

---

## 9\. Sécurité Linux : AppArmor et Sandbox

Firefox possède plusieurs protections :

- Sandbox des processus de contenu.
- Isolation des sites avec Fission.
- Restrictions des accès au système.
- Restrictions des appels système.

### Vérifier AppArmor

Dans un terminal :

bash

```bash
sudo aa-status
```

Vérifier qu'AppArmor est actif.

Ne jamais désactiver AppArmor pour contourner un problème de Firefox.

### Vérifier le sandbox Firefox

Dans la barre d'adresse :

text

```text
about:support
```

Consulter la section Sandbox et vérifier les niveaux d'isolation des processus de contenu.

Ne jamais lancer Firefox avec :

text

```text
--no-sandbox
```

Ne pas désactiver les protections internes du navigateur.

---

## 10\. Paramètres généraux recommandés

| Paramètre | Réglage |
| --- | --- |
| Mises à jour Firefox | Automatiques |
| Protection renforcée | Stricte |
| HTTPS uniquement | Activé |
| DNS sécurisé | Protection accrue |
| Pop-ups | Bloqués |
| Notifications | Bloquées |
| Téléchargements | Demander où enregistrer |
| Extensions | Minimum nécessaire |
| AppArmor | Actif |
| Sandbox | Actif |
| Paramètres expérimentaux | Ne pas modifier sans raison |

---

## 11\. Vérification finale

Commandes à exécuter dans le terminal :

bash

```bash
firefox --version
```

bash

```bash
which firefox
```

bash

```bash
sudo aa-status
```

Puis consulter :

text

```text
about:support
```

Vérifier les informations relatives au sandbox.

---

## 12\. Règles de sécurité à respecter

- Ne jamais désactiver le sandbox.
- Ne jamais désactiver AppArmor.
- Ne pas installer d'extensions inconnues.
- Ne pas ignorer les avertissements de sécurité.
- Ne pas télécharger de logiciels depuis des sites inconnus.
- Ne pas ouvrir les pièces jointes suspectes.
- Ne pas exécuter de commandes copiées depuis des sites douteux.
- Maintenir Linux Mint et Firefox à jour.
- Ne jamais considérer la navigation privée comme une protection contre les logiciels malveillants.

### Important

Un navigateur sécurisé ne garantit pas une protection absolue contre toutes les failles.

Pour consulter des sites réellement suspects, utiliser une machine virtuelle isolée constitue une protection supplémentaire.

**Principe : privilégier les mises à jour, l'isolation et les protections natives plutôt que d'accumuler des modifications expérimentales.**

