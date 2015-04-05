c:\Python25\python.exe pyinstaller-1.3\Configure.py
c:\Python25\python.exe pyinstaller-1.3\Makespec.py jallib.py
c:\Python25\python.exe pyinstaller-1.3\Build.py jallib.spec
copy distjallib\jallib.exe jallibwin.exe
rmdir /S /Q distjallib
rmdir /S /Q buildjallib
