//
//  MMARViewController.m
//  momiaoya
//
//  Created by zhuxu on 2017/10/19.
//  Copyright © 2017年 mmjs. All rights reserved.
//

#import "MMARViewController.h"
#import <ARKit/ARKit.h>

@interface MMARViewController ()


@property (nonatomic, strong) IBOutlet ARSCNView *sceneView;
@property (nonatomic, retain) ARWorldTrackingConfiguration *arConfig;
@property (nonatomic, strong) SCNNode *sphereNode;

@end

@implementation MMARViewController

- (void)viewWillAppear:(BOOL)animated {
    
        [super viewWillAppear:animated];
    
        self.sceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        self.sceneView.delegate = self;
    
        // Container to hold all of the 3D geometry
        SCNScene *scene = [SCNScene new];
        // The 3D cube geometry we want to draw
        SCNBox *boxGeometry = [SCNBox
                               boxWithWidth:0.1
                               height:0.1
                               length:0.1
                               chamferRadius:0.0];
    
        SCNPlane *planeGeo = [SCNPlane planeWithWidth:0.1 height:0.1];
        SCNSphere *sphereGeo = [SCNSphere sphereWithRadius:0.01];
        self.sphereNode = [SCNNode nodeWithGeometry:sphereGeo];
        self.sphereNode.position = SCNVector3Make(0.3, 0, -1);
        [scene.rootNode addChildNode: self.sphereNode];
    
        // The node that wraps the geometry so we can add it to the scene
        SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
        // Position the box just in front of the camera
        boxNode.position = SCNVector3Make(0, 0, -0.5);
        // rootNode is a special node, it is the starting point of all
        // the items in the 3D scene
        [scene.rootNode addChildNode: boxNode];
        // Set the scene to the view
        self.sceneView.scene = scene;
        self.sceneView.autoenablesDefaultLighting = YES;
    //    self.sceneView.allowsCameraControl = YES;
    
        //2.设置视图会话
        self.sceneView.session = [[ARSession alloc] init];
        self.sceneView.session.delegate = self;
    
    //    NSArray *posArr = [SCNVector3Make(0.0, 0.0, 0.0), SCNVector3Make(10.0, 10.0, 10.0)];
    
        //3.自动刷新灯光（3D游戏用到，此处可忽略）
    //    _arSCNself.sceneViewView.automaticallyUpdatesLighting = YES;
    
        [self.view addSubview:self.sceneView];
    
        ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    
        configuration.worldAlignment = ARWorldAlignmentGravity;
    
        //configuration.lightEstimationEnabled = YES;
    
        configuration.planeDetection = ARPlaneDetectionHorizontal;
        [self.sceneView.session runWithConfiguration: configuration];
}

#pragma mark - ARSCNViewDelegate

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    //    ARLightEstimate *estimate = self.sceneView.session.currentFrame.lightEstimate;
    //    if (!estimate) {
    //        return;
    //    }
    //
    ////    NSLog(@"###render");
    //
    //    // A value of 1000 is considered neutral, lighting environment intensity normalizes
    //    // 1.0 to neutral so we need to scale the ambientIntensity value
    //    CGFloat intensity = estimate.ambientIntensity / 1000.0;
    //    self.sceneView.scene.lightingEnvironment.intensity = intensity;
    
    NSArray<ARHitTestResult *> *result = [self.sceneView hitTest:self.view.center types:ARHitTestResultTypeExistingPlaneUsingExtent];
    
    //    NSLog(@"###render:self.sceneView.center:%d", self.sceneView.center.x);
    //    NSLog(@"###render result:%ld", [result count]);
    
}

//会话位置更新（监听相机的移动），此代理方法会调用非常频繁，只要相机移动就会调用，如果相机移动过快，会有一定的误差，具体的需要强大的算法去优化，笔者这里就不深入了
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    NSLog(@"###render 相机移动");
    //    SCNSphere *sphereGeo = [SCNSphere sphereWithRadius:0.01];
    //    SCNBox *boxGeometry = [SCNBox
    //                           boxWithWidth:0.1
    //                           height:0.1
    //                           length:0.1
    //                           chamferRadius:0.0];
    //
    // The node that wraps the geometry so we can add it to the scene
    //    SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
    //    // Position the box just in front of the camera
    //    boxNode.position = SCNVector3Make(frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    // rootNode is a special node, it is the starting point of all
    // the items in the 3D scene
    //    [self.sceneView.scene.rootNode addChildNode: sphereNode];
    self.sphereNode.position = SCNVector3Make(frame.camera.transform.columns[3].x, frame.camera.transform.columns[3].y, -0.1);
    
    NSLog(@"###render %f,%f,%f", frame.camera.transform.columns[3].x, frame.camera.transform.columns[3].y, -0.3);
    
    //    if (self.arType != ARTypeMove) {
    //        return;
    //    }
    //    //移动飞机
    //    if (self.planeNode) {
    //
    //        //捕捉相机的位置，让节点随着相机移动而移动
    //        //根据官方文档记录，相机的位置参数在4X4矩阵的第三列
    //        self.planeNode.position =SCNVector3Make(frame.camera.transform.columns[3].x,frame.camera.transform.columns[3].y,frame.camera.transform.columns[3].z);
    //    }
    
}


/**
 Called when a new node has been mapped to the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that maps to the anchor.
 @param anchor The added anchor.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (![anchor isKindOfClass:[ARPlaneAnchor class]]) {
        return;
    }
    
    // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
    //    NSLog(@"###render");
}

/**
 Called when a node has been updated with data from the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that was updated.
 @param anchor The anchor that was updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    //    Plane *plane = [self.planes objectForKey:anchor.identifier];
    //    if (plane == nil) {
    //        return;
    //    }
    
    // When an anchor is updated we need to also update our 3D geometry too. For example
    // the width and height of the plane detection may have changed so we need to update
    // our SceneKit geometry to match that
    //    [plane update:(ARPlaneAnchor *)anchor];
    //    NSLog(@"###render");
}

/**
 Called when a mapped node has been removed from the scene graph for the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that was removed.
 @param anchor The anchor that was removed.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    // Nodes will be removed if planes multiple individual planes that are detected to all be
    // part of a larger plane are merged.
    //    [self.planes removeObjectForKey:anchor.identifier];
    //    NSLog(@"###render");
}

/**
 Called when a node will be updated with data from the given anchor.
 
 @param renderer The renderer that will render the scene.
 @param node The node that will be updated.
 @param anchor The anchor that was updated.
 */
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    //    NSLog(@"###render");
}

- (void)renderer:(id<SCNSceneRenderer>)renderer
 willRenderScene:(SCNScene *)scene
          atTime:(NSTimeInterval)time {
    
    //    NSLog(@"###render");
}

@end
