# LandryDjassa – Application complète (Supabase + Vercel)

## A. Créer la base de données (Supabase) – 10 minutes
1. Allez sur https://supabase.com → « Start your project » → créez un compte (gratuit).
2. « New project » : nom `landrydjassa`, choisissez un mot de passe de base de données (notez-le), région la plus proche (ex. Europe), puis « Create ». Attendez 2 minutes.
3. Menu de gauche **SQL Editor** → « New query » → ouvrez le fichier `supabase.sql`, copiez TOUT son contenu, collez-le, cliquez **Run**. Message « Success » = tables, sécurité et dossier d’images créés.
4. Menu **Authentication** → **Sign In / Providers** (ou « Providers ») → **Email** : DÉSACTIVEZ « Confirm email » → Save.
   (Les clients s’inscrivent avec leur téléphone ; l’application crée en interne un email du type 0789515505@landrydjassa.app.)
5. Menu **Project Settings** → **API** : copiez **Project URL** et la clé **anon public**.
6. Ouvrez `config.js` et remplacez les deux textes COLLEZ_ICI… par ces deux valeurs (gardez les guillemets). Enregistrez.

## B. Mettre en ligne (Vercel) – 5 minutes
Votre site existe déjà : https://landrydjassa-site.vercel.app/
- **Avec GitHub** : remplacez les fichiers du dépôt par ceux de ce dossier (commit) → Vercel redéploie seul.
- **Avec le terminal** : dans ce dossier, lancez `vercel --prod`.
- **Sans rien installer** : sur vercel.com → « Add New » → « Project » → importez le dossier via GitHub (glisser-déposer de dossier non disponible sur Vercel ; utilisez Netlify Drop si vous préférez : app.netlify.com/drop).

## C. Devenir administrateur
1. Sur le site, cliquez **Compte → S’inscrire** avec VOTRE numéro (ex. 0789515505) et un mot de passe.
2. Dans Supabase → **SQL Editor** → nouvelle requête :
   `update profiles set role='admin' where phone='0789515505';` → Run.
3. Déconnectez-vous puis reconnectez-vous : l’onglet **⚙️ Gestionnaire** apparaît.

## D. Utiliser le gestionnaire
- **Commandes** : voir toutes les commandes, filtrer par statut, faire avancer Nouvelle → Confirmée → En préparation → En livraison → Livrée (ou Annulée), appeler ou écrire au client sur WhatsApp. Le client suit l’avancement dans « Mes commandes ».
- **Articles** : ajouter un article (nom, type : T-shirt, Chemise, Pantalon, Culotte/Short, Ensemble, Complet, Robe, Chaussures, Sacs…, prix, photo), modifier, changer le prix directement dans la liste, supprimer.
- **Clients** : liste des inscrits.

## E. Installer l’application sur téléphone
Android (Chrome) : menu ⋮ → « Installer l’application ». iPhone (Safari) : Partager → « Sur l’écran d’accueil ».

## Sécurité
Chaque client ne voit que SES commandes ; seul l’admin voit tout (règles RLS dans supabase.sql). La clé « anon » est publique par conception. Ne publiez jamais la clé « service_role ».

## F. Mot de passe oublié + messages WhatsApp (version gratuite)
- Fonction serveur : voir fonction-reset-password.ts (étape de déploiement dans le guide donné dans le chat).
- Changement de statut d’une commande → une fenêtre propose « Envoyer le message » : WhatsApp s’ouvre avec le texte prêt pour le client.
