import Menu  from '../app/components/Menu';
import Logo  from '../app/components/Logo';
import Banner from '../app/components/Banner';
import Button from '../app/components/Button';
import RootLayout from '../app/layout';

export default function Home() {
  return (
      <main>
        <div className='static'>
          <Banner></Banner>
          <div className='absolute top-1/3 right-0 pr-4'>
            <Logo></Logo>
          </div>
            <Button>
              <p>Acceuil</p>
            </Button>
        </div>
          
       

      
        

    </main>

  );
}