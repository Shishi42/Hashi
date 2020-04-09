class FenetreModeChrono < Gtk::Box

  #@classe

  def initialize(window,fenetrePre)
    @@fenetre = window
    super(Gtk::Orientation::VERTICAL)

    @classe = true

    tbl = Gtk::Table.new(1,1)
    vBox = Gtk::Box.new(Gtk::Orientation::VERTICAL)
    bouton1 = UnBoutonPerso.new("Facile", "BoutonMenu")
    bouton2 = UnBoutonPerso.new("Normal", "BoutonMenu")
    bouton3 = UnBoutonPerso.new("Difficile", "BoutonMenu")
	boutonRetour = UnBoutonPerso.new("Retour","BoutonMenu")
    bouton1.signal_connect('clicked') {
      @@fenetre.changerWidget(FenetreJeu.new(@@fenetre,fenetrePre ,"easy", @classe))
    }

    bouton2.signal_connect('clicked') {
      @@fenetre.changerWidget(FenetreJeu.new(@@fenetre,fenetrePre ,"normal", @classe))
    }

    bouton3.signal_connect('clicked') {
      @@fenetre.changerWidget(FenetreJeu.new(@@fenetre,fenetrePre ,"hard", @classe))
    }

	boutonRetour.signal_connect('clicked'){
	@@fenetre.changerWidget(fenetrePre)
    }

    vBox.add(bouton1)
    vBox.add(bouton2)
    vBox.add(bouton3)
	vBox.add(boutonRetour)
    tbl.attach(vBox,0,1,0,1, Gtk::AttachOptions::EXPAND, Gtk::AttachOptions::EXPAND, 0, @@fenetre.default_size[1] / 3)
    self.add(tbl)

    self.show_all

  end
end
