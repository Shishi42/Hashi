#Classe représentant un Sommet
class Sommet

	## Partie variables d'instance

  #@listeArete	-> Liste des Aretes du Sommet
  #@position		-> Case dans laquelle le sommet est placé
  #@valeur		-> Entier représentant la valeur du Sommet (nombre d'arête total)
  #@complet		-> Booléen qui définit si un sommet est complet ou non (toutes les aretes occupées)
  #@estErreur     -> Booléen définissant si le sommet est une erreur ou non

  #créer un Sommet proprement
  def self.creer(valeur, position, complet = false)
      objet = new(valeur, position, complet)
      objet.completerInitialize()
      return objet
  end

  # Privatise le new
  private_class_method :new

    ## Partie initialize

	# Initialisation de la classe Sommet
	#
	# === Paramètres
	#
	# * +valeur+ : Valeur du sommet (en général initialisé a 0)
	# * +position+ : Case ou est placé le sommet
  def initialize(valeur, position, complet)
      @valeur = valeur
      @position = position #la case dans lequel est le sommet
      @listeArete = Array.new()
      @complet = complet
      @estErreur = false
  end

  ## Partie accesseurs

	#Accesseur en get et en set sur la position, le booleen complet et la valeur
	attr_accessor :position, :complet, :valeur, :estErreur
	#Accesseur en get sur la liste d'arete
    attr_reader :listeArete

	## Partie méthodes

	##Complète le initialize
    #s'ajoute comme contenu de la case dans laquelle il est et à la liste de sommet de la grille
    def completerInitialize()
        @position.contenu = self
        @position.grille.addSommet(self)
    end

    ##Compte le nombre d'arête
    #parcours toutes les arête pour compter le nombre d'arête
    #
    # === Return
    #
    # * +total+ : Le nombre total d'arête liées au Sommet
    def compterArete()
        total = 0
        @listeArete.each{ |arete|
            total += arete.estDouble ? 2 : 1
        }
        return total
    end

    ##ajoute une arête à la liste de ses arêtes
    def ajouterArete(arete)
        @listeArete << (arete)
    end

    ##retire une arête de la liste de ses arêtes
    def retirerArete(arete)
        @listeArete.delete(arete)
    end

    ## Méthode retournant le nombre de voisins d'un sommet
    #
    # === Return
    #
    # * +nb_voisins+ : Nombre de voisins du sommet
    def compterVoisins()
      voisins = self.getListeVoisins()

      return voisins.size()
    end

    ## Méthode retournant le nombre de voisins d'un sommet auquel il n'est pas relié
    #
    # === Return
    #
    # * +nb_voisins+ : Nombre de voisins du sommet auquel il n'est pas relié
    def compterVoisinsNonRelies()
      voisins = self.getVoisinsNonRelies()

      return voisins.size()
    end

    ## Méthode retournant le nombre de voisins non complets d'un sommet
    #
    # === Return
    #
    # * +nb_voisins+ : Nombre de voisins non complets du sommet
    def compterVoisinsNonComplets()
      return self.getListeVoisinsNonComplets.size()
    end

    ## Méthode retournant le nombre de voisins complets d'un sommet
    #
    # === Return
    #
    # * +nb_voisins+ : Nombre de voisins complets du sommet
    def compterVoisinsComplets()
      return self.getListeVoisinsComplets.size()
    end

    ## Méthode retournant la liste des voisins d'un sommet
    #
    # === Return
    #
    # Une Array contenant la liste des voisins du sommet
    def getListeVoisins()
      voisins = Array.new()

      (@position.x - 1).downto(0) do |i|
        caseCourante = @position.grille.getCase(i, @position.y)
        if(hasSommet(caseCourante))
          voisins.push(caseCourante.contenu)
          break
        end
        if(hasArete(caseCourante))
          if(caseCourante.contenu.sommet1 != self && caseCourante.contenu.sommet2 != self)
            break
          end
        end
      end

      (@position.y - 1).downto(0) do |i|
        caseCourante = @position.grille.getCase(@position.x, i)
        if(hasSommet(caseCourante))
          voisins.push(caseCourante.contenu)
          break
        end
        if(hasArete(caseCourante))
          if(caseCourante.contenu.sommet1 != self && caseCourante.contenu.sommet2 != self)
            break
          end
        end
      end

      (@position.x + 1).upto(@position.grille.longueur) do |i|
        caseCourante = @position.grille.getCase(i, @position.y)
        if(hasSommet(caseCourante))
          voisins.push(caseCourante.contenu)
          break
        end
        if(hasArete(caseCourante))
          if(caseCourante.contenu.sommet1 != self && caseCourante.contenu.sommet2 != self)
            break
          end
        end
      end

      (@position.y + 1).upto(@position.grille.largeur) do |i|
        caseCourante = @position.grille.getCase(@position.x, i)
        if(hasSommet(caseCourante))
          voisins.push(caseCourante.contenu)
          break
        end
        if(hasArete(caseCourante))
          if(caseCourante.contenu.sommet1 != self && caseCourante.contenu.sommet2 != self)
            break
          end
        end
      end

      ## Méthode retournant la liste des voisins non complets d'un sommet
      #
      # === Return
      #
      # Une Array contenant la liste des voisins non complets du sommet
      def getListeVoisinsNonComplets()
        voisins = self.getListeVoisins()
        array = Array.new()

        voisins.each do |x|
          if x.connexionsRestantes != 0
            array.push(x)
          end
        end

        return array
      end

      ## Méthode retournant la liste des voisins complets d'un sommet
      #
      # === Return
      #
      # Une Array contenant la liste des voisins complets du sommet
      def getListeVoisinsComplets()
        voisins = self.getListeVoisins()
        array = Array.new()

        voisins.each do |x|
          if x.connexionsRestantes == 0
            array.push(x)
          end
        end

        return array
      end

      return voisins
    end

  	# Retourne les sommets reliés au sommet.
  	# === Return
  	# * +res+ : res la liste des sommets reliés au sommet.
  	def getVoisins()
  	  res = Array.new()
  	  self.listeArete.each do |a|
  	    if(a.sommet1 != self) then res.push(a.sommet1) end
  	    if(a.sommet2 != self) then res.push(a.sommet2) end
  	  end
  	  return res
  	end

    # Retourne les sommets non reliés au sommet.
  	# === Return
  	# * +res+ : res la liste des sommets non reliés au sommet.
  	def getVoisinsNonRelies()
  	  voisins = self.getListeVoisins()
      relies = self.getVoisins()
  	  return voisins - relies
  	end

    ## Méthode testant si une case possède un sommet
    #
    # === Paramètres
    #
    # * +uneCase+ : Case à tester
    #
    # === Return
    #
    # true si la case possède un sommet, false sinon
    def hasSommet(uneCase)
      if(uneCase != nil)
        return uneCase.contenu.class == Sommet
      else
        return false
      end
    end

    ## Méthode testant si une case possède une arête
    #
    # === Paramètres
    #
    # * +uneCase+ : Case à tester
    #
    # === Return
    #
    # true si la case possède une arête, false sinon
    def hasArete(uneCase)
      if(uneCase != nil)
        return uneCase.contenu.class == Arete
      else
        return false
      end
    end

    ## Méthode permettant d'afficher la valeur d'un sommet
    def afficher()
        print(@valeur)
    end

    ## Méthode calculant le nombre d'arêtes restantes dont un sommet a besoin afin d'être complet
    #
    # === Return
    #
    # Le nombre d'arêtes restantes
    def connexionsRestantes()
      compteur = 0
      self.listeArete.each do |a|
        if(a.estDouble)
          compteur += 2
        else
          compteur += 1
        end
      end
      return @valeur - compteur
    end

    ## Méthode permettant de vérifier si un sommet possède au moins une arête commune avec chacun de ses voisins
    #
    # === Return
    #
    # Retourne vrai si un sommet possède au moins une arête avec chacun de ses voisins, faux sinon
    def areteAvecChaqueVoisin()
      voisinsAreteCommune = Array.new()

      @listeArete.each_with_index do |x|
        if(self != x.sommet1)
          voisinsAreteCommune.push(x.sommet1)
        else
          voisinsAreteCommune.push(x.sommet2)
        end
      end
      return voisinsAreteCommune.uniq().size() == self.compterVoisins()
    end

    ## Méthode vérifiant si le sommet possède une arête vers tel autre sommet
    #
    # === Paramètres
    #
    # * +sommet+ : les sommets de destination de l'arête
    #
    # === Return
    #
    # True si le sommet a une arête vers le sommet, false sinon
    def possedeAreteAvec(sommet)
        aArete = false
        @listeArete.each do |arete|
            if arete.sommet1 == sommet || arete.sommet2 == sommet
                aArete = true
            end
        end
        return aArete
    end

    ## Méthode qui permet de récupérer l'arête avec un tel autre sommet si elle existe
    #
    # === Paramètres
    #
    # * +sommet+ : les sommets de destination de l'arête
    #
    # === Return
    #
    # L'arête entre ces sommets si elle existe, nil sinon
    def donneAreteAvec(sommet)
        if(possedeAreteAvec(sommet))
            @listeArete.each do |arete|
                if arete.sommet1 == sommet || arete.sommet2 == sommet
                    return arete
                end
            end
        end
    end

    ## Méthode permettant de récupérer le sommet de l'autre coté d'une arête
    #
    # === Paramètres
    #
    # * +arete+ : l'arête dont on doit trouver l'autre sommet
    #
    # === Return
    #
    # L'autre sommet relié par l'arête
    def autreSommet(arete)
        if @listeArete.include?(arete)
            if arete.sommet1 == self
                return arete.sommet2
            else
                return arete.sommet1
            end
        end
    end

    ## Méthode permettant de connaître le nombre d'arête que possède le sommet
    #
    # === Return
    #
    # La taille du tableau d'arête
    def nbArete()
        return @listeArete.length()
    end
end
