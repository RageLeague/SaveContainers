Content.AddStringTable("SAVE_CONTAINERS", {
    CONTAINERS = {
        CREATE_NEW = {
            OPT = "Create New Container...",
            TITLE = "Name New Container",
            DESC = "Enter a name to help you identify the profile.",
            SAMPLE = "New Container",

            SUCCESS_DESC = "Container saved as \"{1}\".",
            FAILURE_DESC = "Fail to save container.",
            REQ_NAME = "The container needs a name!",
        },
        LOAD = {
            TITLE = "Confirm Load",
            DESC = "Your current profile will forever be lost if you haven't saved it yet. Additionally, once the container is loaded, the game will be reset.\n\nAre you sure you want to load this container?",

            FAILURE_DESC = "Fail to load container.",
        },
        NA = "N/A",
        SUCCESS = "Success!",
        FAILURE = "Failure!",
        MANAGE_CONTAINERS = "Manage Containers",
    },
})
