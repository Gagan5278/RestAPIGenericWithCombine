# RestAPIGenericWithCombine
A demo to demonstrate how to user Combine framework for rest CURD operations.

## HOW TO USE
    Drag and drop 'Networking' folder into your project. 
    
## SETUP
    Open EndPoint.Swift file and edit 
    
        func makeRequest(for data :K.RequestedItem, with httpMehod: HTTPMethod) -> URLRequest?  {
        var urlComponent = URLComponents()
        urlComponent.path = path
        urlComponent.scheme = "https" //EDIT HERE
        urlComponent.host = "reqres.in". //EDIT HERE
 
 
 EndPoint init accept *path* and *body* for ongoing reqeuest. Pass nil if there is no body required for request.
 
 *K.RequestedHeaderItem* accepts any but we must pass as Dictionary<String, String> for setting Request Headers.
 
 EndPoint is generic type which acceptst<K: PrepareRequest, D: Decodable>. where PrepareRequest is type of Request *PUBLIC* or *PRIVATE*.
 
  In this demo, we can create two types of call
     #### PUBLIC (accesss token not required)
     #### PRIVATE (accesss token required. Useful if you are working with loggin mechanism)
     
## PUBLIC

Either we can create an extension for  EndPoint ass below 

    extension EndPoint where K == FormedRequestKind.Public, D == UserModel {
    static var featuredItems: Self {
        EndPoint(path: "/api/users?page=2",  data: nil)
    } 
    }
    

## OR

we can call directly from our classes as below

        self.cancellable = Networking.makeRequest(for: EndPoint<FormedRequestKind.Public, Bool>(path: "/api/users/2",  data: nil), using: nil, method: .delete).sink(receiveCompletion: {print($0)}) { (response) in
            print(response as Any)

        }
