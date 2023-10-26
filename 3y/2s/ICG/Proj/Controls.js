import * as THREE from 'https://cdn.jsdelivr.net/npm/three@0.118/build/three.module.js';
import { FBXLoader } from 'https://cdn.jsdelivr.net/npm/three@0.118.1/examples/jsm/loaders/FBXLoader.js';
import { GLTFLoader } from 'https://cdn.jsdelivr.net/npm/three@0.118.1/examples/jsm/loaders/GLTFLoader.js';
import { CharacterFSM } from './FiniteStateMachine.js'

class BasicCharacterControllerProxy {
  constructor(animations) {
    this._animations = animations;
  }

  get animations() {
    return this._animations;
  }
} export { BasicCharacterControllerProxy };
let ramiroMesh;
let womenZombie;
let UAmapMesh;

class BasicCharacterController {
  constructor(params) {
    this._Init(params);
  }

  _Init(params) {
    this._params = params;
    this._decceleration = new THREE.Vector3(-0.0005, -0.0001, -10.0);
    this._acceleration = new THREE.Vector3(1, 0.25, 250.0); //3º parametro é para aumentar a velocidade
    this._velocity = new THREE.Vector3(0, 0, 0);
    this._position = new THREE.Vector3();

    this._animations = {};
    this._input = new BasicCharacterControllerInput();
    this._stateMachine = new CharacterFSM(
      new BasicCharacterControllerProxy(this._animations));

    this._LoadModels();

  }

  
  _LoadModels() {
    const loadingManager = new THREE.LoadingManager();

    const progressBar = document.getElementById('progress-bar');

    loadingManager.onProgress = function(item, loaded, total) {
      progressBar.value = loaded/total*100;
    };

    const progressBarContainer = document.querySelector('.progress-bar-container');

    loadingManager.onLoad = function() {
      progressBarContainer.style.display = 'none';
    };

  // loadingManager.onError = () => {
  //   console.log('Loading error!');
  // };


    const UAmap = new GLTFLoader(loadingManager);
    UAmap.load('Models/UAmap.gltf', (gltf) => {
      UAmapMesh = gltf.scene;
      UAmapMesh.scale.set(10, 10, 10);
      UAmapMesh.position.set(7.7, -200, 14.5);
      UAmapMesh.castShadow = true;
      UAmapMesh.receiveShadow = true;
      this._params.scene.add(UAmapMesh);
    }
    );
    // WOMEN
    const womenZ = new GLTFLoader();
    womenZ.load('Models/WomenZombie.gltf', (gltf) => {
      womenZombie = gltf.scene;
      womenZombie.scale.set(20, 20, 20);
      womenZombie.castShadow = true;
      womenZombie.receiveShadow = true;
      womenZombie.position.set(-600, 132.2, -1600);
      this._params.scene.add(womenZombie);

      this._mixersZombies = new THREE.AnimationMixer(womenZombie);
      gltf.animations.forEach((clip) => {
        const action = this._mixersZombies.clipAction(clip);
        action.play();

      });
    });
      // WOMEN

    womenZ.load('Models/WomenZombie.gltf', (gltf) => {
      womenZombie = gltf.scene;
      womenZombie.scale.set(20, 20, 20);
      womenZombie.castShadow = true;
      womenZombie.receiveShadow = true;
      womenZombie.position.set(-70, 132.2, -1250);
      this._params.scene.add(womenZombie);

      this._mixersZombies1 = new THREE.AnimationMixer(womenZombie);
      gltf.animations.forEach((clip) => {
        const action = this._mixersZombies1.clipAction(clip);
        action.play();

      });
    });
      // WOMEN

    womenZ.load('Models/WomenZombie.gltf', (gltf) => {
      womenZombie = gltf.scene;
      womenZombie.scale.set(20, 20, 20);
      womenZombie.castShadow = true;
      womenZombie.receiveShadow = true;
      womenZombie.position.set(-800, 132.2, -1400);
      this._params.scene.add(womenZombie);

      this._mixersZombies2 = new THREE.AnimationMixer(womenZombie);
      gltf.animations.forEach((clip) => {
        const action = this._mixersZombies2.clipAction(clip);
        action.play();

      });
    });
      // WOMEN

    womenZ.load('Models/WomenZombie.gltf', (gltf) => {
      womenZombie = gltf.scene;
      womenZombie.scale.set(20, 20, 20);
      womenZombie.castShadow = true;
      womenZombie.receiveShadow = true;
      womenZombie.position.set(-900, 132.2, -1410);
      this._params.scene.add(womenZombie);

      this._mixersZombies3 = new THREE.AnimationMixer(womenZombie);
      gltf.animations.forEach((clip) => {
        const action = this._mixersZombies3.clipAction(clip);
        action.play();

      });


    });


    const loader = new GLTFLoader();
    loader.load('Models/ramiro.gltf', (gltf) => {
      ramiroMesh = gltf.scene;
      ramiroMesh.scale.set(15, 15, 15);
      ramiroMesh.position.set(-800, 132.2, -1500); //132.2Pes no chao da Reitoria
      ramiroMesh.castShadow = true;
      ramiroMesh.receiveShadow = true;

      this._target = ramiroMesh;
      this._params.scene.add(this._target);

      this._mixer = new THREE.AnimationMixer(this._target);

      this._manager = new THREE.LoadingManager();
      this._manager.onLoad = () => {
        this._stateMachine.SetState('idle');
      };

      const _OnLoad = (animName, anim) => {
        const clip = anim.animations[0];
        const action = this._mixer.clipAction(clip);

        this._animations[animName] = {
          clip: clip,
          action: action,
        };
      };

      const loader = new FBXLoader(this._manager);
      loader.setPath('./animations/');
      loader.load('walk.fbx', (a) => { _OnLoad('walk', a); });
      loader.load('run.fbx', (a) => { _OnLoad('run', a); });
      loader.load('idle.fbx', (a) => { _OnLoad('idle', a); });
      loader.load('Crawl.fbx', (a) => { _OnLoad('Crawl', a); });
    });

    

  }



  get Position() {
    return this._position;
  }

  get Rotation() {
    if (!this._target) {
      return new THREE.Quaternion();
    }
    return this._target.quaternion;
  }

  Update(timeInSeconds) {
    if (!this._stateMachine._currentState) {
      return;
    }

    this._stateMachine.Update(timeInSeconds, this._input);

    const velocity = this._velocity;
    const frameDecceleration = new THREE.Vector3(
      velocity.x * this._decceleration.x,
      velocity.y * this._decceleration.y,
      velocity.z * this._decceleration.z
    );
    frameDecceleration.multiplyScalar(timeInSeconds);
    frameDecceleration.z = Math.sign(frameDecceleration.z) * Math.min(Math.abs(frameDecceleration.z), Math.abs(velocity.z));

    velocity.add(frameDecceleration);

    const controlObject = this._target;
    const _Q = new THREE.Quaternion();
    const _A = new THREE.Vector3();
    const _R = controlObject.quaternion.clone();

    const acc = this._acceleration.clone();
    if (this._input._keys.shift) {
      acc.multiplyScalar(2.0);
    }

    if (this._input._keys.space) {
      acc.multiplyScalar(1.0);
    }

    if (this._input._keys.forward) {
      velocity.z += acc.z * timeInSeconds;
    }
    if (this._input._keys.backward) {
      velocity.z -= acc.z * timeInSeconds;
    }
    if (this._input._keys.left) {
      _A.set(0, 1, 0);
      _Q.setFromAxisAngle(_A, 4.0 * Math.PI * timeInSeconds * this._acceleration.y);
      _R.multiply(_Q);
    }
    if (this._input._keys.right) {
      _A.set(0, 1, 0);
      _Q.setFromAxisAngle(_A, 4.0 * -Math.PI * timeInSeconds * this._acceleration.y);
      _R.multiply(_Q);
    }

    controlObject.quaternion.copy(_R);

    const oldPosition = new THREE.Vector3();
    oldPosition.copy(controlObject.position);

    const forward = new THREE.Vector3(0, 0, 1);
    forward.applyQuaternion(controlObject.quaternion);
    forward.normalize();

    const sideways = new THREE.Vector3(1, 0, 0);
    sideways.applyQuaternion(controlObject.quaternion);
    sideways.normalize();

    sideways.multiplyScalar(velocity.x * timeInSeconds);
    forward.multiplyScalar(velocity.z * timeInSeconds);

    controlObject.position.add(forward);
    controlObject.position.add(sideways);

    this._position.copy(controlObject.position);

    if (this._mixer) {
      this._mixer.update(timeInSeconds);
    }
    if (this._mixersZombies || this._mixersZombies1 || this._mixersZombies2 ||this._mixersZombies3 ) {
      this._mixersZombies.update(timeInSeconds);
      this._mixersZombies1.update(timeInSeconds);
      this._mixersZombies2.update(timeInSeconds);
      this._mixersZombies3.update(timeInSeconds);
    }
  }
} export { BasicCharacterController };


class BasicCharacterControllerInput {
  constructor() {
    this._Init();

  }

  _Init() {
    this._keys = {
      forward: false,
      backward: false,
      left: false,
      right: false,
      space: false,
      shift: false,
    };

    document.addEventListener('keydown', (e) => this._onKeyDown(e), false);
    document.addEventListener('keyup', (e) => this._onKeyUp(e), false);

    // Create an object to keep track of keys being pressed
    var keysPressed = {};

    document.addEventListener("keydown", function (event) {
      keysPressed[event.key] = true;
      updateKeysDisplay();
    });

    document.addEventListener("keyup", function (event) {
      keysPressed[event.key] = false;
      updateKeysDisplay();
    });

    function updateKeysDisplay() {
      var keysElement = document.getElementById("keys");
          
      keysElement.style.position = "fixed";
      keysElement.style.top = "15px";
      keysElement.style.height = "15px";
      keysElement.style.width = "200px";
      keysElement.style.padding = "20px 20px 20px 20px";
      keysElement.style.borderRadius = "20px";
      keysElement.style.backgroundColor = "rgba(0, 0, 0, 0.8)";
      var keysPressedArray = Object.keys(keysPressed).filter(function (key) {
        return keysPressed[key];
      });

      // Clear the display if no keys are being pressed
      if (keysPressedArray.length === 0) {
        keysElement.innerHTML = "";
      } else {
        keysElement.innerHTML = "Keys pressed: " + keysPressedArray.join(", ").toUpperCase();
      }
    }


  }

  _onKeyDown(event) {
    switch (event.keyCode) {
      case 87: // w
        this._keys.forward = true;
        break;
      case 65: // a
        this._keys.left = true;
        break;
      case 83: // s
        this._keys.backward = true;
        break;
      case 68: // d
        this._keys.right = true;
        break;
      case 32: // SPACE
        this._keys.space = true;
        break;
      case 16: // SHIFT
        this._keys.shift = true;
        break;
    }
  }

  _onKeyUp(event) {
    switch (event.keyCode) {
      case 87: // w
        this._keys.forward = false;
        break;
      case 65: // a
        this._keys.left = false;
        break;
      case 83: // s
        this._keys.backward = false;
        break;
      case 68: // d
        this._keys.right = false;
        break;
      case 32: // SPACE
        this._keys.space = false;
        break;
      case 16: // SHIFT
        this._keys.shift = false;
        break;
    }
  }
} export { BasicCharacterControllerInput };