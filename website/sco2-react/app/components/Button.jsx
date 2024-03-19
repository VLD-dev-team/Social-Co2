export default function Button(props){
    return(Button = ({onClick, children}) =>{
        <button onClick={onClick}>
            {children}
        </button>}
    )
      
};