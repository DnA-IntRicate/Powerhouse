Please see 'Docs/User Passwords.txt' for the list of current username-password pairs in the database.

This project uses post-build commands to copy the 'Assets' directory from the project's root to the current build-output directory.
Note that when testing, if you recompile the program from the Delphi IDE it will overwrite the assets in the build-output directory.
Since any changes that the application makes to the database is made to the instance of the 'Assets' directory in the build-output directory, 
these changes would then be lost when the program is recompiled because the post-build commands overwrite these assets with the originals
from the project's root.

GitHub repo: https://github.com/DnA-IntRicate/Powerhouse
