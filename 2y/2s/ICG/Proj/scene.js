// import * as Cannon from 'cannon-es'; // Para criar um mundo de fisica
import * as THREE from 'https://cdn.jsdelivr.net/npm/three@0.118/build/three.module.js';
// import * as SkeletonUtils from './utils/SkeletonUtils.js';
import {Reflector} from 'https://cdn.jsdelivr.net/npm/three@0.118.1/examples/jsm/objects/Reflector.js';
import {BasicCharacterController} from './Controls.js'
import { BufferGeometryUtils } from 'https://cdn.jsdelivr.net/npm/three@0.118.1/examples/jsm/utils/BufferGeometryUtils.js';

// const world = new Cannon.World();
// world.gravity.set(0, -9.82, 0);

class ThirdPersonCamera {
  constructor(params) {
    this._params = params;
    this._camera = params.camera;

    this._currentPosition = new THREE.Vector3();
    this._currentLookAt = new THREE.Vector3();
    this.frontal = false;

    document.addEventListener('keydown', (event) => {
      if (event.key === 'f') {
        this.frontal = !this.frontal;
      }
    });
  }

  _CalculateIdealOffset() {
    const { frontal } = this;
    let idealOffset;

    if (frontal) {
      // idealOffset = new THREE.Vector3(-50, 50, 0); // Position of camera to the side
      idealOffset = new THREE.Vector3(15, 50, 50); // Position of camera Atras e em Cima
    } else {
      idealOffset = new THREE.Vector3(-15, 50, -50); // Position of camera Atras e em Cima
    }

    idealOffset.applyQuaternion(this._params.target.Rotation);
    idealOffset.add(this._params.target.Position);
    return idealOffset;
  }

  _CalculateIdealLookAt() {
    const { frontal } = this;
    let idealLookAt;

    if (frontal) {
      // idealLookAt = new THREE.Vector3(0, 10, 0);
      idealLookAt = new THREE.Vector3(-20, 10, -50); // Para onde olha a câmera centralizar boneco
    } else {
      idealLookAt = new THREE.Vector3(20, 10, 50); // Para onde olha a câmera centralizar boneco
    }

    idealLookAt.applyQuaternion(this._params.target.Rotation);
    idealLookAt.add(this._params.target.Position);
    return idealLookAt;
  }

  Update(timeElapsed) {
    const idealOffset = this._CalculateIdealOffset();
    const idealLookAt = this._CalculateIdealLookAt();

    const t = 1.0 - Math.pow(0.001, timeElapsed);

    this._currentPosition.lerp(idealOffset, t);
    this._currentLookAt.lerp(idealLookAt, t);

    this._camera.position.copy(this._currentPosition);
    this._camera.lookAt(this._currentLookAt);
  }
}
const rainCount = 1000;

let rain, rainBuffer;
class ThirdPersonCameraDemo {
  constructor() {
    this._Initialize();
  }

  _Initialize() {
    this.renderer = new THREE.WebGLRenderer({antialias: true});
    this.renderer.outputEncoding = THREE.sRGBEncoding;
    this.renderer.shadowMap.enabled = true;
    this.renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    this.renderer.setClearColor('rgb(122, 47, 29)', 1.0);   // cor cortina alcance
    this.renderer.setPixelRatio(window.devicePixelRatio);
    this.renderer.setSize(window.innerWidth, window.innerHeight);

    
    document.getElementsByTagName("body")[0].style.overflow = "hidden"; // Esconde a barra de scroll do browser 
    
    const htmlElement = document.querySelector("#Tag3DScene");
    htmlElement.appendChild(this.renderer.domElement);
    window.addEventListener('resize', () => {
      this._OnWindowResize();
    }, false);
    
    this._camera = new THREE.PerspectiveCamera(80, window.innerWidth / window.innerHeight, 1.0, 1000.0);
    this._camera.position.set(-800,132.2,-1500);
    this._scene = new THREE.Scene();

    
    this._scene.fog = new THREE.Fog( 0x7a2f1d, 1, 1000 ); // se mudar para 1500 ja fica feio    

    const directionalLight = new THREE.DirectionalLight(0xFFFFFF, 1.15);
    directionalLight.position.set(-1500, 900, -1000);
    directionalLight.target.position.set(0, 0, 0);
    directionalLight.castShadow = true;
    
    // Configurações adicionais para as sombras da luz direcional
    directionalLight.shadow.bias = -0.001;
    directionalLight.shadow.mapSize.width = 4096;
    directionalLight.shadow.mapSize.height = 4096;
    directionalLight.shadow.camera.far = 1000.0;
    directionalLight.shadow.camera.near = 0.5;
    directionalLight.shadow.camera.left = 50;
    directionalLight.shadow.camera.right = -50;
    directionalLight.shadow.camera.top = 50;
    directionalLight.shadow.camera.bottom = -50;
    
    this._scene.add( directionalLight);
    
    this._scene.add(new THREE.AmbientLight(0xFFFFFF, 0.5));

    /////////////////////////////// Muro >

    let brickTexture = new THREE.TextureLoader().load('img/brick.jpg');

    const positions = [
      { x: -905, z: -1540, rotation: Math.PI / 4.04 },
      { x: -655, z: -1290, rotation: Math.PI / 3.95 }
    ];
    
    const geometries = positions.map(position => {
      const geometry = new THREE.BoxGeometry(750, 25, 15);
      brickTexture.wrapS = THREE.RepeatWrapping;
      brickTexture.wrapT = THREE.RepeatWrapping;
      brickTexture.repeat.set(8, 1); // Define a repetição da textura na direção x (horizontal)

      const brickMaterial = new THREE.MeshStandardMaterial({ map: brickTexture });
      const wall = new THREE.Mesh(geometry, brickMaterial);
      wall.position.set(position.x, 138, position.z);
      wall.rotation.y = position.rotation;
      wall.castShadow = true;
      wall.receiveShadow = true;
      this._scene.add(wall);
      return wall;
    });
    
    const distance = geometries[0].position.distanceTo(geometries[1].position);
    
    const wall1 = createWall(distance, geometries[0], geometries[1]);
    wall1.position.set((geometries[0].position.x + geometries[1].position.x) / 2 - 260,138,(geometries[0].position.z + geometries[1].position.z) / 2 + 260);

    const wall2 = createWall(distance, geometries[1], geometries[0]);
    wall2.position.set((geometries[1].position.x + geometries[0].position.x) / 2 + 260,138,(geometries[1].position.z + geometries[0].position.z) / 2 - 260);

    
    this._scene.add(wall1);
    this._scene.add(wall2);
    
    function createWall(distance, start, end) {
      const geometry = new THREE.BoxGeometry(distance, 25, 15);
      const brickMaterial = new THREE.MeshStandardMaterial({  map: brickTexture  });
      const wall = new THREE.Mesh(geometry, brickMaterial);
      wall.rotation.y = start.rotation.y + (90 * Math.PI / 180);
      return wall;
    }

    
    /////////////////////////////// < Muro 
    
    /////////////////////////////// Chão >

    // Carrega a textura do chão
let groundTexture = new THREE.TextureLoader().load('img/chao3.jpg');
groundTexture.wrapS = THREE.RepeatWrapping;
groundTexture.wrapT = THREE.RepeatWrapping;
groundTexture.repeat.set(2,2);



// Cria o material usando Texture Blending
const groundMaterial = new THREE.MeshStandardMaterial({
  map: groundTexture,
  side: THREE.DoubleSide,
});

// Cria o mesh do chão
const groundMesh = new THREE.Mesh(new THREE.PlaneGeometry(740, 360), groundMaterial);

groundMesh.position.set(-782, 132.25, -1418);
groundMesh.rotation.x = -Math.PI / 2;
groundMesh.rotation.z = Math.PI / 4.04;

groundMesh.receiveShadow = true;

this._scene.add(groundMesh);


    /////////////////////////////// < Chão

    /////////////////////////////// Espelho >
    let mirrorOption = {
      clipBias: 0.004,  // limits reflection
      textureWidth: window.innerWidth * window.devicePixelRatio, // scales by pixel ratio of device
      textureHeight: window.innerHeight * window.devicePixelRatio, // 
      color: 0x808080,
      multisample: 4, //improve image quality
    }
    let mirrorGeometry = new THREE.BoxGeometry(30,40,2);
    let mirror = new Reflector(mirrorGeometry, mirrorOption);
    mirror.position.set(-860,152,-1575);
    // mirror.rotateZ(Math.PI/8); //Inclinado um pouco para cima
    mirror.rotateY(Math.PI/4); 

    let woodTexture = new THREE.TextureLoader().load('img/madeira.jpg');
    woodTexture.wrapS = THREE.RepeatWrapping;
    woodTexture.wrapT = THREE.RepeatWrapping;
    woodTexture.repeat.set(2, 2);
    // Create BoxGeometry with wood texture
    let frameEdge1 = new THREE.Mesh(new THREE.BoxGeometry(4, 40, 4), new THREE.MeshStandardMaterial({ map: woodTexture }));
    let frameEdge2 = new THREE.Mesh(new THREE.BoxGeometry(4, 40, 4), new THREE.MeshStandardMaterial({ map: woodTexture }));
    let frameEdge3 = new THREE.Mesh(new THREE.BoxGeometry(4, 35, 4), new THREE.MeshStandardMaterial({ map: woodTexture }));
    frameEdge3.rotateX(Math.PI/2);
    frameEdge3.rotateZ(-Math.PI/4);
    frameEdge3.rotateZ(Math.PI/2);
    frameEdge1.position.set(-850,152,-1585);
    frameEdge2.position.set(-870,152,-1565);
    frameEdge3.position.set(-860,172,-1575);
  
    // Crie um grupo para agrupar os objetos
    const mirrorGroup = new THREE.Group();

    // Adicione o espelho e os objetos de moldura como filhos do grupo
    mirrorGroup.add(mirror, frameEdge1, frameEdge2, frameEdge3);

    // Defina a posição e a rotação do grupo
    mirrorGroup.position.set(10, 1, 0);
    
    // Adicione o grupo à cena
    this._scene.add(mirrorGroup);


    /////////////////////////////// < Espelho
    /////////////////////////////// Chuva >
    // add rain particles
    rainBuffer = new THREE.BufferGeometry();
    let posRain = new Float32Array(rainCount*3);
    for (let i = 0; i < (rainCount*3); i+=3) { // dimensões 4000x1000x3000
      posRain[i] = Math.random() * 2000 - 1000;
      posRain[i+1] = Math.random() * 500 -250;
      posRain[i+2] = Math.random() * 2000 - 1000;
    }
    rainBuffer.setAttribute('position', new THREE.BufferAttribute(posRain, 3));
    let rainMaterial = new THREE.PointsMaterial({
      color: 0xfcf0ed,
      size: 0.2,
      transparent: true,
      opacity: 0.9,
      depthWrite: false,
      // format oval
      sizeAttenuation: true,
    });

    rain = new THREE.Points(rainBuffer, rainMaterial);
    rain.position.set(-800,210,-1500);
    this._scene.add(rain);
    /////////////////////////////// < Chuva


    // this._InitializeAudio();
     
    this._mixers = [];
    this._mixersZombies = [];
    this._previousRAF = null;

    this._LoadAnimatedModel();
    this._RAF();
  }

  _LoadAnimatedModel() {
    const params = {
      camera: this._camera,
      scene: this._scene,
    }
    this._controls = new BasicCharacterController(params);

    this._thirdPersonCamera = new ThirdPersonCamera({
      camera: this._camera,
      target: this._controls,
    });
  }

  _OnWindowResize() {
    this._camera.aspect = window.innerWidth / window.innerHeight;
    this._camera.updateProjectionMatrix();
    this.renderer.setSize(window.innerWidth, window.innerHeight);
  }
  
  _RAF() {
    
    requestAnimationFrame((t) => {
      if (this._previousRAF === null) {
        this._previousRAF = t;
      }

      this._RAF();

      const positions = rain.geometry.attributes.position.array;
      rain.geometry.attributes.position.needsUpdate = true;
      for (let i = 0; i < (rainCount*3); i+=3) {
        positions[i+1] -= 2.0 + Math.random() * 0.1;
        if (positions[i+1] < (-300*Math.random())) {
          positions[i+1] = 100;
        }
      }

      this.renderer.render(this._scene, this._camera);
      this._Step(t - this._previousRAF);
      this._previousRAF = t;
    });
  }

  _Step(timeElapsed) {
    const timeElapsedS = timeElapsed * 0.001;
    if (this._mixers) {
      this._mixers.map(m => m.update(timeElapsedS));
    }
    if (this._mixersZombies) {
      this._mixersZombies.map(m => m.update(timeElapsedS));
    }

    if (this._controls) {
      this._controls.Update(timeElapsedS);
    }

    this._thirdPersonCamera.Update(timeElapsedS);
  }
}

let _APP = null;

window.addEventListener('DOMContentLoaded', () => {
  _APP = new ThirdPersonCameraDemo();
});

// to put camera over persona 
function _LerpOverFrames(frames, t) {
  const s = new THREE.Vector3(0, 0, 0);
  const e = new THREE.Vector3(100, 0, 0);
  const c = s.clone();

  for (let i = 0; i < frames; i++) {
    c.lerp(e, t);
  }
  return c;
}

function _TestLerp(t1, t2) {
  const v1 = _LerpOverFrames(100, t1);
  const v2 = _LerpOverFrames(50, t2);
  console.log(v1.x + ' | ' + v2.x);
}

_TestLerp(0.01, 0.01);
_TestLerp(1.0 / 100.0, 1.0 / 50.0);
_TestLerp(1.0 - Math.pow(0.3, 1.0 / 100.0), 
          1.0 - Math.pow(0.3, 1.0 / 50.0));

