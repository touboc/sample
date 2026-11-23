-- Yazi configuration: enable zoxide database updates.
-- Directories visited in Yazi will be added to zoxide history.

require("zoxide"):setup {
    update_db = true,
}
