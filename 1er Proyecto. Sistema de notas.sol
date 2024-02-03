// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.8.11;
pragma experimental ABIEncoderV2;

contract notas{

    //Creamos una variable donde se guarde la direccion del profesor
    address public profesor;

    constructor (){
        profesor = msg.sender; 
    }

    //Mapping para relacionar el hash de los alumnos con sus respectivas notas
    mapping(bytes32 => uint) Notas;

    //Arry dinamico de los alumnos que piden revision de su examen
    string [] revisiones;


    //Eventos
    event alumno_evaluado(bytes32, uint);
    event alumno_revision(string); 

    //Modifier para que solo el profesor pueda ejecutar una funcion
    modifier SoloProfesor(address _address){
        require(_address == profesor, 'Sali de aca gordo teton');
        _;
    }


    //Funcion mpara evaluar alumnos
    function CalificarAlumno(string memory _IDAlumno, uint _nota) public SoloProfesor(msg.sender){
        //Obtenemos el hash del ID del alumno
        bytes32 hash_IDAlumno = keccak256(abi.encodePacked(_IDAlumno));
        //Agregamos al mapping el hash que identifica al alumno con su nota
        Notas[hash_IDAlumno] = _nota;
        //Emitimos el evento al evaluar un alumno
        emit alumno_evaluado(hash_IDAlumno, _nota);
    }

    //Funcion para vizualizar notas
    function VerNota(string memory _IDAlumno) public view returns(string memory, uint){
        //Obtengo el hash del ID del alumno
        bytes32 hash_IDAlumno = keccak256(abi.encodePacked(_IDAlumno));
        //Retorno el ID del alumno y su nota(obtenida del mapping Notas)
        return(_IDAlumno, Notas[hash_IDAlumno]);
    }

    //Funcion para pedir la revision de un examen
    function RevisionExamen(string memory _IDAlumno) public{
        //Agrego al arry de revisiones el ID del alumno que quiere una revision 
        revisiones.push(_IDAlumno);
        //Emito un evento 
        emit alumno_revision(_IDAlumno);
    }

    function QuienQuiereRevisiones() public view SoloProfesor(msg.sender) returns(string [] memory){
        return revisiones;
    }
}
