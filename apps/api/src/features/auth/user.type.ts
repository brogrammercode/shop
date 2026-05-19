type User  = {
    readonly id: string;
    readonly name: string;
    readonly email: string;
    readonly username: string;
    readonly image: string;
    readonly cover: string;
    readonly bio: string;
    readonly created_at: Date;
    readonly updated_at: Date;
}

type UserActivity = {
    readonly id: string;
    readonly username: string;
    readonly type: string;
    readonly module: string;
    readonly title: string;
    readonly description: string;
    readonly created_at: Date;
    readonly updated_at: Date;
}

export { User, UserActivity };