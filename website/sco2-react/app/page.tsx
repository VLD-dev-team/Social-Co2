{/*importation des différents composants utilisés pour la page web*/}
import Menu  from '../app/components/Menu';
import Menu2 from '../app/components/Menu2';
import Menu3 from '../app/components/Menu3';
import Menu4 from '../app/components/Menu4';
import Button from '../app/components/Button';

export default function Home() {
  return (
      <main>
        <link rel="icon" href="./logo.png" sizes="any" /> {/*ajout d'un favicon*/} 
        <div className='relative'>
          <img className='w-full h-auto' src="./banner.png" alt="banner"/>
            <div className='md:absolute sm:relative sm:top-44 sm:right-4 top-0 right-0'>
              <img className='md:h-auto sm:h-1/2 sm:w-1/2 md:w-full' src="./logo.png" alt="logo"/>
            </div>
        </div>
        <div className='absolute top-4 left-4 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'> 
        <Button message={"c'est ok"}>
          Accueil
        </Button>
      </div>
      <div className='absolute top-4 right-4 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'>
        <Button message={"c'est ok"}>
          S'inscrire
        </Button>
        <div className='absolute top-0 right-0 sm:right-36 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'>
          <Button message={"c'est ok"}>
            Se connecter
          </Button>
        </div>
      </div>

            <div className="md:flex-row flex-col grid grid-cols-1 md:grid-cols-2 gap-14 sm:pl-4 md:pl-52 pr-10 pb-24"> {/*alignement des éléments de la page à l'aide d'une grille*/}
              <div className="col-span-1 md:col-span-2"><Menu></Menu></div>
              <div className=""><Menu2></Menu2></div>
              <div className="w-full h-auto"><img src="./image1.png" alt="image1"/></div>
              <div className=""><Menu3></Menu3></div>
              <div className="w-full h-auto"> <img src="./acceuil-1.png" alt="image2"/></div>
              <div className=''><Menu4></Menu4></div>
              <div className='w-full h-auto'><img src="./messagerie1.png" alt="image3" /></div>
            </div>

    </main>

  );
}