import Menu from '../app/components/Menu';
import Menu2 from '../app/components/Menu2';
import Menu3 from '../app/components/Menu3';
import Menu4 from '../app/components/Menu4';

export default function Home() {
  return (
    <main>
      <div className='relative'>
        <img className='w-auto h-auto' src="./banner.png" alt="banner" />
        <div className='absolute top-44 right-4'>
          <img className='h-auto w-auto' src="./logo.png" alt="logo" />
        </div>
      </div>
      <div className='absolute top-4 right-4 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'>
        <button onClick={function Handleclick() {
          alert('Login');
        }}>
          Login
        </button>
        <div className='absolute top-0 right-36 border-transparent rounded-full bg-white p-1 text-nowrap pr-4 pl-4'>
          <button onClick={function Handleclick() {
            alert('Register');
          }}>
            Register
          </button>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-28 pl-52 pr-10 pb-24">
        <div className="col-span-2"><Menu></Menu></div>
        <div className=""><Menu2></Menu2></div>
        <div className=""><img src="./image1.png" alt="image1" /></div>
        <div className=""><Menu3></Menu3></div>
        <div className=""> <img src="./acceuil-1.png" alt="image2" /></div>
        <div className=''><Menu4></Menu4></div>
        <div className=''> <img src="./messagerie1.png" alt="image3" /></div>
      </div>

    </main>

  );
}