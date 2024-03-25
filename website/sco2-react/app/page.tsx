import Menu  from '../app/components/Menu';
import Logo  from '../app/components/Logo';
import Banner from '../app/components/Banner';
import Button from '../app/components/Button';
import Card from '../app/components/Card';
import RootLayout from '../app/layout';

export default function Home() {
  return (
      <main>
        <div className='static'>
          <Banner></Banner>
            <div className='absolute top-48 right-0 pr-4'>
              <Logo></Logo>
          </div>
        </div>
          <div className='absolute top-4 left-4 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'> 
            <Button message={"c'est ok"}>
              Accueil
            </Button>
          </div>
          <div className='absolute top-4 right-4 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4 inner-shadow'>
            <Button message={"c'est ok"}>
              S'inscrire
            </Button>
            <div className='absolute top-0 right-36 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'>
              <Button message={"c'est ok"}>
                Se connecter
              </Button>
            </div>
          </div>
          <div className='flex'>
            <div className='basis-4/5'></div>
            <div className='basis-4/5'></div>
            <div><Menu></Menu></div>
            <div className='basis-44'></div>
          </div>
          <div className=''>
            <Card></Card>
          </div>
       

      
        

    </main>

  );
}