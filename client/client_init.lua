Core = exports.vorp_core:GetCore()
BccUtils = exports['bcc-utils'].initiate()
FeatherMenu = exports['feather-menu'].initiate()
Progressbar = exports["feather-progressbar"]:initiate()
MiniGame = exports['bcc-minigames'].initiate()
DBG = BccUtils.Debug:Get('bcc-boats', Config.devMode.active)

if DBG then
    DBG:Enable()
    DBG:Info('Boats debug initialized')
end
