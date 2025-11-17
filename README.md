# My Archlinux dotfiles (Final Version)

## This setup will configure my applications the way I want them to be.
This configuration uses symlinks using linux stow

To install stow

```bash
sudo pacman -S stow
```

Then clone the content of this repository into a folder inside your `home` directory.

```bash
git clone https://www.github.com/lazzy/arch_dotfiles.git dotfiles
```

Finally, you can run
```bash
stow .
```

## Managing monitors
I used [nwg-displays](https://www.github.com/nwg-piotr/nwg-displays) to find the perfect monitor layout for my PC.

## Changing the wallpaper
Since issues with waking up the PC with hypridle (Vertical monitor not showing the wallpaper after waking the PC up), I have created a deamon to run everytime the system wake up. So, when changing the wallpaper, use the following script.

```bash
matugen-wall.sh <wallpaper_path>
```
