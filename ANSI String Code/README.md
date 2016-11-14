
#Ansistring, PAnsiChar and AnsiChar On The NextGen Platform

The Delphi NextGen compiler does not support AnsiString. The code here uses *Class Operators* to implement **AnsiString** record types on NextGen platforms. More details http://delphinotes.innovasolutions.com.au/posts/ansistring-on-an-android-device


For our purposes automatic  conversions between the various forms of the Delphi String implementations was a problem not a **feature**. Not requiring string conversions made our *AnsiString* types much simpler.

By using records with class operators we have been able to reconstruct AnsiString, AnsiChar and PAnsiChar. Adding this File to the uses clause of your files wrapped with {$IFDEF NextGen} ... {$ENDIF} Should see your source code compilable by both Old Gen and NextGen compilers with minimal conditional defines.  



