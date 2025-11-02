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
