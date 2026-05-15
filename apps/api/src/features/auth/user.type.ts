type User  = {
    readonly id: string;
    readonly name: string;
    readonly email: string;
    readonly image: string ;
    readonly created_at: Date;
    readonly updated_at: Date;
}

export { User };