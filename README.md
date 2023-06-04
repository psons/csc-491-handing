# Firebase is disabled.
Code areas where things were commented out are mared with:
// DISABLING FIRRESTORE

# Firebase notes.
after adding Firebase package dependencies.

I did not check all the packages.  This is a guess at what I need.
I'm hoping to keep the heaft down.

$ git diff | grep productName
 			productName = "End Goal";
+			productName = FirebaseAppCheck;
+			productName = FirebaseAuth;
+			productName = "FirebaseAuthCombine-Community";
+			productName = FirebaseDatabase;
+			productName = FirebaseDatabaseSwift;
+			productName = FirebaseFirestore;
+			productName = "FirebaseFirestoreCombine-Community";
+			productName = FirebaseFirestoreSwift;

# Firebase Auth instructions
My Doc: https://docs.google.com/document/d/1q-_tqbYldrTUIBhFGLSlEwvl6TpvxKBVNN02pGOfJ8k/edit?usp=sharing
Detail: https://firebase.google.com/docs/auth/ios/password-auth#create_a_password-based_account
The Firebase Auth instructions call ouyt requirement for the following imports:
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
