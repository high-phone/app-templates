export enum AttachmentType {
    media = 'media',
    contact = 'contact',
    voice = 'voice',
    note = 'note',
    location = 'location'
}

export interface Attachments {
    [AttachmentType.media]: {
        url: string;
        metadata?: { thumbnail?: string }
    };
    [AttachmentType.contact]: {
        name?: string;
        number: string;
        photo?: string
    };
    [AttachmentType.voice]: {
        url: string 
    };
    [AttachmentType.note]: {
        title?: string;
        content: string;
        color?: string
    };
    [AttachmentType.location]: {
        coords: { x: number, y: number, z: number }
    }
}

export interface Attachment<T extends AttachmentType> {
    type: T,
    content: Attachments[T]
}