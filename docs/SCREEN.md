# Screen Configuration

The stock screen implementation on the Flashforge AD5M (Pro) is not optimized for direct interaction with Fluidd or Moonraker. 
This is because FlashForge's firmware is designed to work exclusively with its own services and does not handle external control well.

For example, you can't just do `RESTART` or `SAVE_CONFIG` via Klipper's console — it freezes the screen, and you have to reboot the printer afterward because you can't do anything with a frozen firmware application.

You can view the [mod.cfg](/mod.cfg) file with macros that make the screen work with bare Klipper/Moonraker.

Also, the screen consumes a lot of RAM — about 7-15 MiB—and with the printer's limited memory of just 128 MiB, it's a dealbreaker.

However, we don't have to use the stock screen. To free up resources, we can run the printer headless (in early mod builds) or use the alternative Feather screen implementation.

## Alternative Screen

To reduce resource usage, the mod provides an alternative Feather screen implementation.
This lightweight screen consumes minimal resources and is designed to display essential print information, such as print status, temperature, and estimated remaining time.
While it does not currently support user input, it is highly extensible and customizable.

By using the Feather screen, you can significantly reduce resource usage while maintaining essential functionality.
This is particularly beneficial for users running complex prints or using additional modifications.

### Switching to Feather Screen / Headless

Disabling the stock screen changes how the printer works.
It no longer loads the `MESH_DATA` profile or applies the **Z-Offset** automatically.

To apply the Z-Offset, you can use the global mod parameter (prefered), described here: [Configuration](/docs/CONFIGURATION.md).
Alternatively, you can use the START_PRINT option, described here: [Slicing](/docs/SLICING.md)

To enable the Feather screen and free up resources, set the following mod parameter:

```bash
SET_MOD PARAM="display" VALUE="FEATHER"
```

This will disable the stock screen and activate the Feather screen immediately. **Make sure to wait until the current print finishes before doing this! :)**

If you want to free up more resources or run a custom screen implementation yourself, run this command:

```bash
SET_MOD PARAM="display" VALUE="HEADLESS"
```


> [!NOTE]
> You must configure **Wi-Fi** or **Ethernet** before disabling the stock screen.  
> After a reboot, the mod connects to a network automatically, but it uses the configuration created by the stock screen.   
> **For Wi-Fi** configuration stored here: `/etc/wpa_supplicant.conf`   

> [!WARNING]
> Only DHCP mode is supported!

**If you lose access** to the printer after disabling the screen, flash this image:  
- [Adventurer5M-ForgeX-feather-off.tgz](https://github.com/DrA1ex/ff5m/releases/download/1.2.0/Adventurer5M-ForgeX-feather-off.tgz)   

Rename it to match your printer version.

**Alternatively**, you can temporarily prevent the mod from booting using the [Dual Boot](/docs/DUAL_BOOT.md) option.   
Then edit the `variables.cfg` file to disable the `display` parameter manually:

```bash
# Enable stock screen using script
/opt/config/mod/.shell/commands/zdisplay.sh stock

# Or change parameter in variables.cfg using this script
/opt/config/mod/.shell/commands/zconf.sh /opt/config/mod_data/variables.cfg --set "display='STOCK'"

# Or edit manually
nano /opt/config/mod_data/variables.cfg
```


### Extending Screen Functionality

The Feather screen is not a monolithic application but rather a flexible system that can be extended to display additional information.
To customize or extend the screen's functionality, you can use the typer tool, located at `/root/printer_data/bin/typer`.
This tool allows you to draw or print information on the screen.

To see usage instructions, run:
```bash
/root/printer_data/bin/typer --help
```

It's not suitable for a full UI, but it consumes almost no resources and allows you to print any information you need.

Documentation for `typer` is available here: [link](/docs/TYPER.md)   

For examples you can view [feather.cfg](/config/feather.cfg) for macros and [screen.sh](/.shell/screen.sh) script.
Implementation of Feather itself you can find in [feather_screen.py](/.py/klipper/plugins/feather_screen.py)

### Custom Loading and Splash Screens

Set any image as your splash/loading screen.

- Create PNG image (800×480)
- Convert to raw bgra with xz compression:

#### Example of Conversion (ImageMagick)

```sh
convert -size 800x480 xc:none ./splash.png -geometry +0+0 -composite -depth 8 bgra:- | xz -c > "splash.img.xz"
```

#### Installation

Place in `Fluidd Config → mod_data`:   
- Loading screen: `load.img.xz`   
- Splash screen: `splash.img.xz`   
