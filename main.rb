require 'gtk3'

require_relative './Interface/FenetreMenu.rb'
require_relative './Interface/FenetreMenuJouer.rb'
require_relative './Interface/FenetreParametres.rb'
require_relative './Interface/FenetreModesDifficultes.rb'
require_relative './Interface/UnLabelPerso.rb'
require_relative './Interface/UnBoutonPerso.rb'
require_relative './Interface/FenetreModeChrono.rb'
require_relative './Interface/FenetreVictoire.rb'
require_relative './Interface/FenetreClassement.rb'
require_relative './Interface/FenetreTuto.rb'
require_relative './Interface/FenetreJeu.rb'
require_relative './Interface/FenetreJeuTuto.rb'
require_relative './Interface/FenetreTest.rb'
require_relative './Tutoriel/Tutoriel.rb'
require_relative './Interface/BoutonTuto.rb'

# require_relative 'Fenetre1.rb'



class Main < Gtk::Window
    $cheminRacineHashi = __dir__

    def initialize
        super()
        self.name="WindowPrincipale"
        self.move(0,0)

        self.fullscreen()

        self.set_default_size(Gdk::Screen::width < 3000 ? Gdk::Screen::width : Gdk::Screen::width/2,Gdk::Screen::height)
        self.set_resizable(false)
        self.set_title("Jeu Hashi")
        self.window_position=Gtk::WindowPosition::CENTER

        css=Gtk::CssProvider.new
        css.load(path: "#{$cheminRacineHashi}/Interface/css/style.css")
        #inversez les commentaires pour
        #css.load(path: "/home/hashiwokakero/Hashi/Interface/css/style.css")
        Gtk::StyleContext::add_provider_for_screen(Gdk::Screen.default,css,
            Gtk::StyleProvider::PRIORITY_APPLICATION)

            self.signal_connect('destroy') {
                Gtk.main_quit
            }

            self.add(FenetreMenu.new(self))


            self.show_all
            Gtk.main
    end

    def changerWidget(nouveau)
        self.remove(self.child).add(nouveau)
        self.show_all
        self
    end


end

puts $cheminRacineHashi
Main.new