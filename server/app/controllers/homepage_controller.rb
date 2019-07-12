class HomepageController < ApplicationController

    def home
        render file: '/Users/ahawk/Development/Module-3-Final-Project/server/index.html'
    end

end