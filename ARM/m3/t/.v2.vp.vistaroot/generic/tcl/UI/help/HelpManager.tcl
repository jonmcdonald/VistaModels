namespace eval ::UI::help {

  class HelpHandler {
    public method show {topic}
  }
  
  class HelpManager {
    private variable helpHandler
    
    public method registerHandler {_helpHandler} {
      set helpHandler $_helpHandler
    }

    public method showTopic {topic} {
      $helpHandler show $topic
    }

    public method showURL {url} {
      $helpHandler show_url $url
    }
  }

  HelpManager helpManager

}
