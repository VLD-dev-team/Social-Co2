import Menu  from '../app/components/Menu';
import Menu2 from '../app/components/Menu2';
import Menu3 from '../app/components/Menu3';
import Menu4 from '../app/components/Menu4';
import Button from '../app/components/Button';




export default function Home() {
  return (
      <main>
        <div className='relative'>
          <img className='w-auto h-auto' src="./banner.png" alt="banner" />
            <div className='absolute top-0 sm:top-44 right-0 sm:right-4'>
              <img className='h-auto md:w-full sm:w-1/2' src="./logo.png" alt="logo" />
            </div>
        </div>
          <div className='absolute top-4 left-4 border-transparent rounded-full bg-white p-1 text-nowrap font-medium pr-4 pl-4 shadow-inner'> 
            <Button>
              Accueil
            </Button>
          </div>
          <div className='absolute top-4 right-4 border-transparent rounded-full bg-white p-1 text-nowrap font-medium pr-4 pl-4 shadow-inner'>
            <Button>
              S'inscrire
            </Button>
            <div className='absolute top-0 right-36 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4 shadow-inner'>
              <Button>
                Se connecter
              </Button>
            </div>
          </div>

            <div className="md:flex-row flex-col grid grid-cols-1 md:grid-cols-2 sm:pl-4 gap-12 md:pl-52 pr-10 pb-24">
              <div className="col-span-1 md:col-span-2"><Menu></Menu></div>
              <div className=""><Menu2></Menu2></div>
              <div className="h-auto w-full"><img src="./image1.png" alt="image1"/></div>
              <div className=""><Menu3></Menu3></div>
              <div className="h-auto w-full"> <img src="./acceuil-1.png" alt="image2"/></div>
              <div className=''><Menu4></Menu4></div>
              <div className='h-auto w-full'><img src="./messagerie1.png" alt="image3" /></div>
            </div>

    </main>

  );
}