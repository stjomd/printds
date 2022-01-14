import ArgumentParser

struct App: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        commandName: "printds",
        abstract: "Print double sided documents manually with ease.",
        version: "0.0.1"
    )

    @Argument(help: "The path to the document.")
    var input: String
    
}

App.main()
