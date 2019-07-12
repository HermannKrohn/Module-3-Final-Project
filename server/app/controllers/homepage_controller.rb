class HomepageController < ApplicationController

    def home
        render file: File.absolute_path("./index.html")
    end

end