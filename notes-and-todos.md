# Abstract

When I was trying to use vscode with "correct fonts" endedup in this mess!!


## Fonts, locale and more

```bash
fc-match emoji | grep 'NotoColorEmoji.ttf: "Noto Color Emoji" "Regular"'

fc-cache -rfv
```

TODO: it was IA regurgitation, test it!

You can represent it by using the following character codes or names:

    Memory Chip: U+F5F8
        Description: This symbol is a representation of a microchip or memory module, commonly used to represent memory.

    Memory or Drive: U+F0C7
        Description: This is often used to symbolize a drive or storage device, which can also be associated with memory.

    RAM Stick: U+F200
        Description: This resembles a memory stick, making it a direct representation of RAM.

    Chip: U+F11C
        Description: Similar to a microchip, it can symbolize any electronic component, including RAM.


```bash
gnome-font-viewer
fontforge

echo $TERM
python3 -c "import sys; print(sys.getdefaultencoding())"
```


```bash
python3 -c "print('\U0001f4af')"
python3 -c "print(chr(0x01f4e6))"


echo -e "\uf538"
python3 -c "print('\uf538')"


printf '%x' \'📦 | xargs -I{} fc-list ":charset={}"
printf '%x' \' | xargs -I{} fc-list ":charset={}"

type echo
type printf

python3 -c "print(format(ord('📦'), '#08x'))"
python3 -c "print(format(ord(''), '#08x'))"

python3 -c "print(format(ord('💯'), '#08x'))"
```



```bash
python3 -c "print(chr(128175))"
python3 -c "print(chr(ord('💯')))"
python3 -c "print(ord(chr(128175)))"
python3 -c "print(chr(ord('💯')))"

python3 -c "assert ord('💯') == 128175, 'Some how it failed!'"
python3 -c "assert chr(128175) == '💯', 'Some how it failed!'"

python3 -c "assert chr(ord('💯')) == chr(128175), 'Some how it failed!'"
python3 -c "assert ord(chr(128175)) == ord('💯'), 'Some how it failed!'"
```


```bash
python3 -c "print(chr(63578))"
python3 -c "print(ord(''))"
python3 -c "print(chr(ord('')))"

python3 -c "chr(ord('')) == ''"

python3 -c "print(int('U+F5F8'[2:], 16))"

python3 -c "print(chr(int('U+F5F8'[2:], 16)))"
python3 -c "print('\uF5F8')"

python3 -c "print(chr(int('U+039B'[2:], 16)))"
```


```bash
python3 -c "print(chr(63578))"
python3 -c "print(ord(''))"
```

```bash
printf '%x' \'  | xargs -I{} fc-list ":charset={}"
printf '%x' \'⚙️  | xargs -I{} fc-list ":charset={}"
```

```bash
printf '%x' \'  | xargs -I{} fc-list ":charset={}"
printf '%x' \'  | xargs -I{} fc-list ":charset={}"
```

```bash
python3 -c "print('\u279c')"
python3 -c "print(b'\u279c'.decode('unicode-escape'))"
```

## batery


```bash
printf '%x' \' | xargs -I{} fc-list ":charset={}"
python3 -c "print(chr(62850))"
python3 -c "print(chr(62851))"
python3 -c "print(ord(''))"
```

TODO: adapt it
https://github.com/thexyno/nixos-config/blob/86953ea92592527b6d1c4a5289942ed533ab56fd/hm-modules/nushell/default.nix#L117-L138

```bash
python3 -c "print(chr(int('U+2601'[2:], 16)))"
python3 -c "print(chr(int('U+E049'[2:], 16)))" # Wrong?
python3 -c "print(u'\uE049')" # Wrong?
```

```bash
python3 -c "print(ord(''))"
```


## NBSP


Really relevant references:
- https://www.thelinuxrain.org/articles/how-to-deal-with-nbsps-in-a-terminal
- https://unix.stackexchange.com/a/696875
- https://note.nkmk.me/en/python-chr-ord-unicode-code-point/
- https://www.digitalocean.com/community/tutorials/how-to-work-with-unicode-in-python
- https://stackoverflow.com/questions/34732718/why-isnt-there-a-font-that-contains-all-unicode-glyphs#comment98898044_54486679
- https://unix.stackexchange.com/a/393740
- https://sheet.shiar.nl/font/code2000?q=9728
- https://utf8-icons.com/utf-8-character-62968
- https://www.utf8-chartable.de/unicode-utf8-table.pl?start=62784&names=-
- https://www.reddit.com/r/NixOS/comments/1h1nc2a/nerdfonts_has_been_separated_into_individual_font/?rdt=53281
- https://github.com/NixOS/nixpkgs/issues/86601#issuecomment-622988031
- https://www.iemoji.com/view/emoji/185/animals-nature/cloud
- https://github.com/google/mozc/issues/1055
- https://stackoverflow.com/a/69780841
- https://www.reddit.com/r/DistroHopping/comments/115dr1l/what_is_the_best_font_rendering_for_linux_out/?rdt=34638


```bash
echo $LOCALE_ARCHIVE
```
Refs.:
- https://discourse.nixos.org/t/nix-zsh-wont-print-utf-8-but-system-zsh-will/34113


Investigate:
```bash
setxkbmap -query
```

To see the events of copy/paste:
```bash
xev
```

```bash
gnome-font-viewer
```


```bash
python3 -c "print('A\u00A0B\u00A0C')"
echo 'A\u00A0B\u00A0C' | cut -d' ' -f1
```

Given `U+2394` search for an font:
```bash
fc-list :charset=2394:style=regular -f '%{file}\n'
```
Refs.:
- https://www.reddit.com/r/archlinux/comments/1af46vq/some_unicode_characters_not_rendering_properly/



convert -list font

```bash
python3 -c "print('\u019B')"
python3 -c "print(chr(int('U+019B'[2:], 16)))"
python3 -c "import unicodedata; print(unicodedata.lookup('LATIN SMALL LETTER LAMBDA WITH STROKE'))"
python3 -c "import unicodedata; print(unicodedata.name('ƛ'))"

python3 -c "print(chr(int('U+03B1'[2:], 16)))"
python3 -c "print(chr(int('U+1F50B'[2:], 16)))"
```


```bash
python3 -c "print('\u03B1')"
python3 -c "print('\u03B2')"
python3 -c "print('\u03B3')"
python3 -c "print('\u03B4')"
```


```bash
magick -pointsize 500 label:"W" output.pdf
```


```bash
ffmpeg \
-f lavfi \
-i color=c=white:s=640x480 \
-vframes 1 \
-vf "drawtext=text='A':font='Courier New':fontcolor=black:fontsize=500:x=(w-text_w)/2:y=(h-text_h)/2" \
'output_%03d.png' -y

ffmpeg \
-f lavfi \
-i color=c=white:s=640x480 \
-vframes 1 \
-vf "drawtext=text='📦':font='Courier New':fontcolor=black:fontsize=500:x=(w-text_w)/2:y=(h-text_h)/2" \
'output_%03d.png' -y

ffmpeg -f lavfi -i color=c=white:s=640x480 -vf \
"drawtext=text='📦':font='Courier New':fontcolor=black:fontsize=500:x=(w-text_w)/2:y=(h-text_h)/2" \
-vframes 1 output.png -y


ffmpeg \
-f lavfi \
-i color=c=white:s=640x480 \
-vframes 1 \
"drawtext=text='📦':font='Noto Color Emoji':fontcolor=black:fontsize=500:x=(w-text_w)/2:y=(h-text_h)/2" \
'output_%03d.png' -y

ffmpeg -f lavfi -i color=c=white:s=640x480 -vf \
"drawtext=text='📦':font='Noto Color Emoji':fontcolor=black:fontsize=500:x=(w-text_w)/2:y=(h-text_h)/2" \
-vframes 1 output.png -y
```

```bash
fc-list | grep -i "Noto Color Emoji"
```

```bash
ffmpeg -f lavfi -i color=c=white:s=640x480 -vf \
"drawtext=text='⏱':font='Noto Color Emoji':fontcolor=black:fontsize=500:x=(w-text_w)/2:y=(h-text_h)/2" \
-vframes 1 output.png -y
```



```bash
tee -a script.py <<'EOF'

from PIL import Image, ImageDraw, ImageFont

# Image dimensions
width, height = 640, 480

# Create a white image
image = Image.new("RGB", (width, height), color="white")

# Set up the drawing context
draw = ImageDraw.Draw(image)

# Font settings (ensure the font is accessible)
font = ImageFont.truetype("Courier New.ttf", 500)  # Make sure this font is installed on your system

# Text settings
text = "A"
fontcolor = (0, 0, 0)  # Black

# Get text size to center it
text_width, text_height = draw.textsize(text, font=font)

# Position text in the center
x_position = (width - text_width) // 2
y_position = (height - text_height) // 2

# Draw the text on the image
draw.text((x_position, y_position), text, font=font, fill=fontcolor)

# Save the image
image.save("output.png")
EOF

python3 script.py
```

TODO: scripts that test fonts
- https://github.com/ryanoasis/nerd-fonts/issues/1550#issuecomment-2016490683
- https://github.com/NixOS/nixpkgs/issues/327846#issuecomment-2233675798
- https://github.com/ryanoasis/nerd-fonts/issues/1059#issuecomment-1406341696
- https://stackoverflow.com/a/60924535
- https://unix.stackexchange.com/a/626919



TODO: openCV scripts 
- https://www.geeksforgeeks.org/template-matching-using-opencv-in-python/ 
- https://docs.opencv.org/3.4/d4/dc6/tutorial_py_template_matching.html
- https://stackoverflow.com/questions/55673886/what-is-the-difference-between-c-utf-8-and-en-us-utf-8-locales#comment121475766_68593911 
- https://stackoverflow.com/a/33497921 


TODO: cloud symbols
- https://www.htmlsymbols.xyz/unicode/U+2601
- https://github.com/ohmyzsh/ohmyzsh/issues/1906#issuecomment-275733922


TODO: 
https://www.fbrs.io/nix-hm-reflections/


TODO:
https://discourse.nixos.org/t/setting-up-vscode-for-podman-on-nixos/42675


TODO: examples of extensions
- https://github.com/averyanalex/dotfiles/blob/50686dc20fe9992542b9678f273e4d97afe4faae/dev/vscode.nix#L129
- https://github.com/liamphmurphy/nix/blob/29a50e4db060174b04e3138cfa866c8a76c5b596/nixos/desktop-apps.nix#L11
- https://github.com/dr460nf1r3/dr460nixed/blob/10a53b63dea0aeee1e9289ddf635e2523b5c9bb8/nixos/pve-dragon-1/code-server.nix#L30
- https://github.com/commonkestrel/nixfiles/blob/7fd8639f7b20890503b81c1c26f9a1bc390f2109/modules/home/editor.nix#L19
- https://github.com/Joaqim/dotfiles/blob/2d309e60c95653354a8f88cf22862f2278835d50/home-manager/modules/vscode.nix#L137-L140
- https://github.com/massix/nixos/blob/617599afce8d0baa3a5c37f5a9354fac7e978cc3/home/modules/coding.nix#L173-L187
- https://github.com/heywoodlh/flakes/blob/381e10ef44cbd83b7408faa29be0dae1fbd90085/vscode/flake.nix#L101-L164
- https://github.com/raexera/yuki/blob/2f32b58fb8cde99f1e684729edb4cfc4376380e9/home/raexera/editors/vscode/usersettings.nix#L168
- https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix#L28-L31
- 


LC_ALL

```bash
cat /etc/locale.gen 

ls -l /var/lib/locales/supported.d/
```

```bash
echo "Some text with accents: é ç ñ" | iconv -f UTF-8 -t ISO-8859-1 > file.txt
file -i file.txt
iconv -f ISO-8859-1 -t UTF-8 file.txt
file -i file.txt
```

```bash
echo -e "Line 1\r\nLine 2 with é" | iconv -f UTF-8 -t ISO-8859-1 > win_encoded.txt
file -i win_encoded.txt
iconv -f ISO-8859-1 -t UTF-8 win_encoded.txt
file -i win_encoded.txt
```

TODO: unix2dos


TODO: file, iconv, encguess, enca, npm's detect-file-encoding-and-language / dfeal, python, perl, php, uchardet
- https://stackoverflow.com/questions/805418/how-can-i-find-encoding-of-a-file-via-a-script-on-linux#comment138474230_34502845




### The nautilus bug


```bash
uchardet
```
Refs.:
- 


```bash
sudo find $HOME \! -user $USER -ls
```
Refs.:
- https://askubuntu.com/a/1207428


https://www.reddit.com/r/Ubuntu/comments/1b804kw/i_need_a_better_file_manager_than_nautilus/


Did try to set the locale:
```bash
sudo locale-gen en_US.UTF-8

sudo update-locale LANG=en_US.UTF-8
```
Refs.:
- https://askubuntu.com/a/1219274
- https://superuser.com/questions/316230/changing-the-current-set-locale-on-a-linuxubuntu#comment2927410_316235


```bash
head -n30 /var/crash/_usr_bin_nautilus.1000.crash
```
