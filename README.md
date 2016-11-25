#Delphi NextGen Compiler Utilities

Delphi for Mobiles comes with a new compiler. This Repository is for me to share any Library code I have used to help port existing Old Compiler code to the Next Gen Compiler. 

##Ansistring, PAnsiChar and AnsiChar

The Delphi NextGen compiler does not support AnsiString and I needed this feature so the first *Library* published relates to an ANSI String Solution. The code here uses *Class Operators* to implement **AnsiString** record types on NextGen platforms. More details http://delphinotes.innovasolutions.com.au/posts/ansistring-on-an-android-device

##Monitor Object Lifetimes Under AUTREFCOUNT

AutoRefCount is mandatory with the new generation compiler, this theoretically removes the obligation and necessity of managing object lifetimes.  ( http://docwiki.embarcadero.com/RADStudio/Seattle/en/Automatic_Reference_Counting_in_Delphi_Mobile_Compilers )
However for any system which has any sort of complex object relationships this does not work and the task of making sure objects are freed becomes more difficult with ARC than without it. More details http://delphinotes.innovasolutions.com.au/posts/checking-object-lifetimes-with-autorefcount

##List Containers For Integers, Class Types, Pointers and Records

The Module ISListCnters.Pas offers a number of Containers which will let you store class types, records and miscellaneus memory pointers in Tstrings derivatives and enables you to persist Objects in a List container containing pointers. More Details http://delphinotes.innovasolutions.com.au/posts/under-autorefcount-pointers-records-and-integers-clash-with-object-properties




