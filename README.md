# Templator

#### API for template management for Vapor 3

Every body needs to manage some templates from time to time in their application. Templator provides a database agnostic solution to the problem, optionally providing a configurable set of API endpoints to allow user to manage these from any interface.

Default template sources can be hosted remotely on github for example and reloaded/reset at will.

### Usage

#### Configuration

To setup API routes do (more on routes [here](#api_routes))

```swift
try Templates<PostgreSQLDatabase>.setup(routes: router)
```

Next you need to add the Templator table / model to your migrations

```swift
try Templates<PostgreSQLDatabase>.setup(models: &migrationConfig, database: .db)
```

optionally, you can also setup an additional endpoint authentication through a closure as follows


```swift
try Templator.Templates<ApiCoreDatabase>.setup(routes: router, permissionCheck: { (routeEnumValue, req) -> EventLoopFuture<Bool> in
    // authenticate
})
```

To register required services, run

```swift
try Templates<PostgreSQLDatabase>.setup(services: &services)
```
Apart from registering [Leaf]() as a templating system, `Templates<PostgreSQLDatabase>` is registered to be used internally in your application.

#### API routes

Routes available are as follows:

* [GET] `templates` - list templates
* [POST] `templates` - create a template
* [GET] `templates/:id` - get a single template
* [PUT] `templates/:id` - modify a template
* [DELETE] `templates/:id` - delete a template

Model for modification or creation of a template is:

```json
{
	"name": "test-template",
	"source": "<h1>Welcome#(name)</h1>",
	"link": "http://link_to_a_remote_template_source.com"
}
```

#### Retrieving templates in your app is super simple

```swift
let templator = try req.make(Templates<ApiCoreDatabase>.self)
let htmlFuture = templator.get(EmailTemplateInvitationHTML.self, data: templateModel, on: req)
return htmlFuture.flatMap(to: View.self) { htmlTemplate in
   /// Use template
}
```

#### Creating templates

To create a new template, conform your struct to a `Source<Database>`

```swift
/// Basic invitation template
public class EmailTemplateInvitationHTML: Source {
	
	public typealias Database = PostgreSQLDatabase
    
    /// Name of the template
    public static var name: String = "email.invitation.html"
    
    public static var link: String = "https://raw.githubusercontent.com/LiveUI/ApiCore/master/Resources/Templates/email.invitation.html.leaf"
    
    public static var deletable: Bool = false
    
}
```

A little trick if you want to avoid defining the Database for each template is to create a protocol wrapper

```swift
public protocol TemplateSource: Source where Self.Database == ApiCoreDatabase { }

public class EmailTemplateInvitationPlain: TemplateSource {
    
    /// Name of the template
    public static var name: String = "email.invitation.plain"
    
    public static var link: String = "https://raw.githubusercontent.com/LiveUI/ApiCore/master/Resources/Templates/email.invitation.plain.leaf"
    
    public static var deletable: Bool = false
    
}
```

