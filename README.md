# rr-sitonchairs

Target any chair, bench, stool or couch and sit on it. Works on the whole map with no coords to set up. Good for waiting rooms, parks, bars, restaurants, pretty much anywhere.

Free and open source from [RR Interactive](https://playrosie.com), the team behind the ROSIE FiveM city.
[Docs](https://playrosie.com/docs/rr-sitonchairs/) · [Store page](https://playrosie.com/store/rr-sitonchairs/) · [Discord](https://discord.gg/VMXzjgzN7R) · [Our other scripts](https://playrosie.com/store/)

## Features

- 530+ chair, bench, stool, sofa and couch models from the base game and DLC interiors
- Won't let you sit on top of someone who's already in the seat
- Press E to stand. If you ragdoll, get hurt or jump in a car it cleans up on its own
- Seat height is measured from the bottom of the prop, so it lines up no matter where the model origin is
- `/sitdebug` shows the model name and height for any chair that sits wrong, then you fix it with one line in the config

Works on Qbox, QBCore, ESX or standalone. It only needs ox_lib and ox_target.

## Install

1. Put `rr-sitonchairs` in your resources folder
2. Make sure `ox_lib` and `ox_target` start before it
3. Add `ensure rr-sitonchairs` to your server.cfg

## Adding chairs

Add the model name to `Config.Models`. If you type a name that doesn't exist nothing breaks, it just never matches. MLO furniture works the same way.

If a chair sits too high, too low or backwards, turn on `/sitdebug`, sit on it, and add an override:

```lua
Config.Overrides['some_prop_name'] = { z = 0.60, heading = 0.0 }
```

## License

[GNU GPL v3.0](LICENSE). Use it, change it, share it. If you share or sell a modified version it has to stay open source.

Made by [RR Interactive](https://playrosie.com).
