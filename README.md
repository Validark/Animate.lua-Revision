#Revision of the default Animate.local.lua script
This should be placed in: StarterPlayer > StarterCharacterScripts > Animate.local.lua

Backwards compatibilty with putting StringValues into the Character is not supported. Why? Because you shouldn't be doing that anyway. Use a BindableEvent or Module or something.

Emotes are removed because they shouldn't be controlled by a Chatted event.

Other than that, this version is much lighter, much more efficient, and readable
